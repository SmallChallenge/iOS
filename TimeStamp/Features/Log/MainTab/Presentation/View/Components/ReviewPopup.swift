//
//  ReviewPopup.swift
//  Stampic
//
//  Created by 임주희 on 4/30/26.
//

import SwiftUI

// 리뷰유도 팝업
struct ReviewPopup: View {
    let didTapReviewButton:() -> Void
    let didTapFeedbackButton:() -> Void
    let didTapDismissButton:() -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 28){

            // 제목, 컨텐츠
            VStack(alignment: .center, spacing: 8) {
                Text("스탬픽과 함께하는 기록,\n만족하시나요?")
                    .font(.H3)
                    .foregroundStyle(Color.gray50)

                Text("소중한 의견을 들려주시면 스탬픽이 더욱 나아질 수 있어요.")
                    .font(.Body2)
                    .foregroundStyle(Color.gray300)
                    .multilineTextAlignment(.center)
            }
            
            VStack (alignment: .center, spacing: 15){
                
                MainButton(title: "별점 5점으로 응원하기 ❤️"){
                    didTapReviewButton()
                }
                
                
                MainButton(title: "개선 의견 보내기", colorType: .secondary) {
                    didTapFeedbackButton()
                }
                
                
                Button {
                    didTapDismissButton()
                } label: {
                    Text("나중에 할게요")
                        .font(.Btn1)
                        .foregroundStyle(.gray400)
                }
            }
        }
        .padding(.top, 32)
        .padding([.bottom, .horizontal], 20)
        .frame(maxWidth: .infinity)
        .background(Color.gray800)
        .cornerRadius(16)
    }
}

#Preview {
    ReviewPopup(
        didTapReviewButton: {},
        didTapFeedbackButton: {},
        didTapDismissButton: {}
    )
        .padding(20)
}
