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

    /// 피드 목록
    @Published var feeds: [Feed] = []

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
                let result = try await useCase.feeds(
                    category: currentCategory,
                    lastPublishedAt: nextCursorPublishedAt,
                    lastImageId: nextCursorId,
                )

                await MainActor.run {
                    // 피드 업데이트
                    if isRefresh || feeds.isEmpty {
                        feeds = result.feeds
                    } else {
                        feeds.append(contentsOf: result.feeds)
                    }

                    // 페이지네이션 정보 업데이트 - 마지막 피드의 정보를 저장
                    if let lastFeed = feeds.last {
                        nextCursorId = lastFeed.imageId
                        nextCursorPublishedAt = lastFeed.publishedAt
                    }
                    hasNext = result.sliceInfo.hasNext

                    isLoading = false
                    Logger.success("피드 로드 완료: \(result.feeds.count)개")
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

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()

        resetPagination()
        isLoading = true
        isRefreshing = true

        // 최소 1초 딜레이 (로딩 UI 표시를 위해)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        do {
            let result = try await useCase.feeds(
                category: currentCategory,
                lastPublishedAt: nil,
                lastImageId: nil
            )

            feeds = result.feeds

            if let lastFeed = feeds.last {
                nextCursorId = lastFeed.imageId
                nextCursorPublishedAt = lastFeed.publishedAt
            }
            hasNext = result.sliceInfo.hasNext

            isLoading = false
            isRefreshing = false
            Logger.success("새로고침 완료: \(result.feeds.count)개")
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
                        feeds[index] = updatedFeed
                    }
                    isLoading = false
                    Logger.success("좋아요 토글 완료")
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    show(.unknownRequestFailed)
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
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    if case let NetworkError.serverFailed(code, _) = error,
                       code == "SELF_REPORT_NOT_ALLOWED"{
                        show(.reportToMineFailed)
                    } else {
                        show(.unknownRequestFailed)
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

    /// 메뉴 열기/닫기
    func selectFeedForMenu(id: Int?) {
        selectedFeedIdForMenu = id
    }

    // MARK: - Private Methods

    private func resetPagination() {
        nextCursorId = nil
        nextCursorPublishedAt = nil
        hasNext = true
    }
}
