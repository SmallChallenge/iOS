//
//  CommunityViewModel.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import Foundation
import Combine
import UIKit

final class CommunityViewModel: ObservableObject, MessageDisplayable {

    private let useCase: CommunityUseCaseProtocol

    // MARK: - Output Properties

    /// 피드와 배너가 섞인 리스트 (5개마다 배너 삽입)
    @Published var communityListItems: [CommunityListItem] = []

    /// 피드 ViewData 목록 (View에서 isEmpty, last 체크용)
    @Published var feedList: [FeedViewData] = []

    /// 로딩
    @Published var isLoading: Bool = false

    /// 새로고침 중 (커스텀 로딩뷰용)
    @Published var isRefreshing: Bool = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    /// 메뉴가 열린 피드 ID
    @Published var selectedFeedIdForMenu: Int?

    // MARK: - Private Properties

    /// 피드 목록 (내부 데이터 관리용)
    private var feeds: [Feed] = []

    /// 페이지네이션 정보
    private var nextCursorId: Int?
    private var nextCursorPublishedAt: String?
    private var hasNext: Bool = true

    /// 현재 선택된 카테고리
    private var currentCategory: String?

    // MARK: - Init

    init(useCase: CommunityUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Input Methods

    /// 피드 목록 조회 (첫 로드 또는 새로고침)
    func loadFeeds(category: String? = nil, isRefresh: Bool = false
    ) {
        guard hasNext || isRefresh else { return }
        guard !isLoading else { return }

        // 카테고리가 변경되면 새로고침
        if category != currentCategory {
            resetPagination()
            currentCategory = category
        }

        if isRefresh {
            resetPagination()
        }

        isLoading = true

        Task {
            do {
                let (newFeeds, newHasNext) = try await fetchFeeds(
                    category: currentCategory,
                    lastPublishedAt: nextCursorPublishedAt,
                    lastImageId: nextCursorId
                )

                await MainActor.run {
                    // 피드 업데이트
                    updateFeeds(newFeeds, append: !(isRefresh || feeds.isEmpty))

                    // 페이지네이션 정보 업데이트 - 마지막 피드의 정보를 저장
                    if let lastFeed = feeds.last {
                        nextCursorId = lastFeed.imageId
                        nextCursorPublishedAt = lastFeed.publishedAt
                    }
                    hasNext = newHasNext

                    isLoading = false
                    Logger.success("피드 로드 완료: \(newFeeds.count)개")
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    show(.unknownRequestFailed)
                    Logger.error("피드 로드 실패: \(error)")
                }
            }
        }
    }

    /// 다음 페이지 로드
    func loadMore() {
        loadFeeds(category: currentCategory, isRefresh: false)
    }

    /// 새로고침
    @MainActor
    func refresh() async {
        guard !isLoading else { return }

        resetPagination()
        isLoading = true
        isRefreshing = true

        // 최소 1초 딜레이 (로딩 UI 표시를 위해)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        do {
            let (newFeeds, newHasNext) = try await fetchFeeds(
                category: currentCategory,
                lastPublishedAt: nil,
                lastImageId: nil
            )

            updateFeeds(newFeeds)

            if let lastFeed = feeds.last {
                nextCursorId = lastFeed.imageId
                nextCursorPublishedAt = lastFeed.publishedAt
            }
            hasNext = newHasNext

            isLoading = false
            isRefreshing = false
            Logger.success("새로고침 완료: \(newFeeds.count)개")
        } catch {
            isLoading = false
            isRefreshing = false
            show(.unknownRequestFailed)
            Logger.error("새로고침 실패: \(error)")
        }
    }

    /// 좋아요 토글
    func toggleLike(imageId: Int) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                try await useCase.like(imageId: imageId)

                await MainActor.run {
                    // 피드 목록에서 해당 피드의 좋아요 상태 업데이트
                    if let index = feeds.firstIndex(where: { $0.imageId == imageId }) {
                        var updatedFeed = feeds[index]
                        updatedFeed = Feed(
                            imageId: updatedFeed.imageId,
                            accessURL: updatedFeed.accessURL,
                            nickname: updatedFeed.nickname,
                            profileImageURL: updatedFeed.profileImageURL,
                            isLiked: !updatedFeed.isLiked,
                            likeCount: updatedFeed.isLiked ? updatedFeed.likeCount - 1 : updatedFeed.likeCount + 1,
                            publishedAt: updatedFeed.publishedAt
                        )
                        updateFeed(at: index, with: updatedFeed)
                    }
                    isLoading = false
                    Logger.success("좋아요 토글 완료")
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    show(.likeFailed)
                    Logger.error("좋아요 실패: \(error)")
                }
            }
        }
    }

    /// 신고하기
    func report(imageId: Int) {
        guard !isLoading else { return }
        Logger.debug("신고하기 \(imageId)")
        isLoading = true
        Task {
            do {
                try await useCase.report(imageId: imageId)

                await MainActor.run {
                    show(.reportSuccess)
                    Logger.success("신고 완료: \(imageId)")

                    // 신고한 피드를 목록에서 제거
                    removeFeed(imageId: imageId)

                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    if case let NetworkError.serverFailed(code, _) = error,
                       code == "SELF_REPORT_NOT_ALLOWED"{
                        show(.reportToMineFailed)
                    } else {
                        show(.reportFailed)
                    }
                    Logger.error("신고 실패: \(error)")
                    isLoading = false
                }
            }
        }
    }

    /// 신고 취소하기
    func cancelReport(imageId: Int) {
        guard !isLoading else { return }

        Task {
            do {
                try await useCase.cancelReport(imageId: imageId)
                await MainActor.run {
                    toastMessage = "신고가 취소되었어요."
                    Logger.success("신고 취소 완료: \(imageId)")
                }
            } catch {
                await MainActor.run {
                    show(.unknownRequestFailed)
                    Logger.error("신고 취소 실패: \(error)")
                }
            }
        }
    }
    
    /// 차단하기
    func block(nickname: String){
        guard !isLoading else { return }
        Logger.debug("차단하기 \(nickname)")
        isLoading = true
        Task {
            do {
                try await useCase.block(nickname: nickname)
                await MainActor.run {
                    show(.blockSuccess)
                    Logger.success("차단 완료: \(nickname)")

                    // 차단한 사용자의 모든 피드를 목록에서 제거
                    removeFeedsByNickname(nickname: nickname)

                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    Logger.error("차단 실패: \(error)")
                    if case let NetworkError.serverFailed(code, _) = error,
                     code == "SELF_BLOCK_NOT_ALLOWED" {
                        show(.blockToMineFailed)
                    } else {
                        show(.blockFailed)
                    }
                    isLoading = false
                }
            }
        }
    }

    /// 메뉴 열기/닫기
    func selectFeedForMenu(id: Int?) {
        selectedFeedIdForMenu = id
    }

    // MARK: - Private Methods

    /// 피드 데이터 fetch (공통 로직)
    private func fetchFeeds(
        category: String?,
        lastPublishedAt: String?,
        lastImageId: Int?
    ) async throws -> (feeds: [Feed], hasNext: Bool) {
        let result = try await useCase.feeds(
            category: category,
            lastPublishedAt: lastPublishedAt,
            lastImageId: lastImageId
        )
        return (result.feeds, result.sliceInfo.hasNext)
    }

    /// 피드 목록 업데이트 (교체 또는 추가)
    private func updateFeeds(_ newFeeds: [Feed], append: Bool = false) {
        if append {
            feeds.append(contentsOf: newFeeds)
            feedList.append(contentsOf: newFeeds.map { $0.toViewData() })
        } else {
            feeds = newFeeds
            feedList = newFeeds.map { $0.toViewData() }
        }
        buildCommunityListItems()
    }

    /// 특정 인덱스의 피드 업데이트
    private func updateFeed(at index: Int, with feed: Feed) {
        feeds[index] = feed
        feedList[index] = feed.toViewData()

        // communityListItems에서 해당 feed만 찾아서 업데이트 (배너는 영향 없음)
        if let itemIndex = communityListItems.firstIndex(where: {
            if case .feed(let feedData) = $0, feedData.imageId == feed.imageId {
                return true
            }
            return false
        }) {
            communityListItems[itemIndex] = .feed(feed.toViewData())
        }
    }

    /// 피드 제거
    private func removeFeed(imageId: Int) {
        feeds.removeAll { $0.imageId == imageId }
        feedList.removeAll { $0.imageId == imageId }
        buildCommunityListItems()
    }

    /// 특정 닉네임의 모든 피드 제거
    private func removeFeedsByNickname(nickname: String) {
        feeds.removeAll { $0.nickname == nickname }
        feedList.removeAll { $0.nickname == nickname }
        buildCommunityListItems()
    }

    private func resetPagination() {
        nextCursorId = nil
        nextCursorPublishedAt = nil
        hasNext = true
    }

    /// feedList로부터 배너가 삽입된 communityListItems 생성
    private func buildCommunityListItems() {
        var items: [CommunityListItem] = []
        let isLoggedIn = AuthManager.shared.isLoggedIn

        for (index, feed) in feedList.enumerated() {
            items.append(.feed(feed))

            // 5개마다 배너 삽입 (0, 1, 2, 3, 4 다음에 배너, 즉 5번째마다)
            if (index + 1) % 5 == 0 {
                let bannerSequence = (index + 1) / 5 - 1  // 0, 1, 2, 3, ...
                let bannerData = BannerViewData.create(sequence: bannerSequence, isLoggedIn: isLoggedIn)
                items.append(.banner(bannerData))
            }
        }

        communityListItems = items
    }
}
