//
//  BannerViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 1/10/26.
//

import Foundation
import SwiftUI

struct BannerViewData {
    let id: Int
    let type: BannerStyleType
    let color: Color
    let message: String

    enum BannerStyleType {
        case guest
        case user
    }

    // 메시지와 색상을 함께 정의
    struct BannerContent {
        let message: String
        let color: Color
    }

    // 타입별 배너 컨텐츠 배열
    static let guestBanners: [BannerContent] = [
        BannerContent(
            message: "나만의 갓생 기록도 자랑하고 싶다면?\n지금 로그인하고 첫 게시물을 올려보세요!",
            color: Color(hex: "FFC5A4")
        ),
        BannerContent(
            message: "로그인하고 마음에 드는 게시물에 좋아요를 눌러 응원해 보세요!",
            color: Color(hex: "F6DFFF")
        ),
        BannerContent(
            message: "함께 기록하면 더 즐거워요.\n좋아요를 눌러 응원해 보세요!",
            color: Color(hex: "CFEFFF")
        ),
        BannerContent(
            message: "이미 많은 분이 갓생을 기록 중이에요.\n로그인하고 스탬픽 메이트가 되어주세요!",
            color: Color(hex: "E6FF8A")
        )
    ]

    static let userBanners: [BannerContent] = [
        BannerContent(
            message: "이미 많은 분들이 갓생을 기록 중이에요.\n여러분의 오늘 하루는 어땠나요?",
            color: Color(hex: "FFC5A4")
        ),
        BannerContent(
            message: "나만 보긴 아까운 갓생 기록들,\n로그인하고 친구들과 공유해 볼까요?",
            color: Color(hex: "E6FF8A")
        ),
        BannerContent(
            message: "투박한 일상 사진도 스탬픽으로 예쁘게!\n지금 촬영 버튼을 눌러보세요.",
            color: Color(hex: "CFEFFF")
        ),
        BannerContent(
            message: "오늘의 미션: 갓생 사진 1장 올리기!\n아직 늦지 않았어요, 지금 기록해 보세요.",
            color: Color(hex: "F6DFFF")
        )
    ]

    // 배너 데이터 생성 헬퍼
    static func create(sequence: Int, isLoggedIn: Bool) -> BannerViewData {
        let type: BannerStyleType = isLoggedIn ? .user : .guest
        let banners = isLoggedIn ? userBanners : guestBanners
        let bannerIndex = sequence % banners.count  // 4개 배너를 순환
        let banner = banners[bannerIndex]

        return BannerViewData(
            id: sequence,
            type: type,
            color: banner.color,
            message: banner.message
        )
    }
}
