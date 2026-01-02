//
//  ErrorMessage.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation

// MARK: - Display Type

enum MessageDisplayType {
    case toast  // 토스트 메시지
    case alert  // 팝업 메시지
}

// MARK: - App Message

enum AppMessage {
    // MARK: 에러 메시지
    
    /// 기본 메세지
    case unknownRequestFailed
    
   
    /// 로그인 필요
    case loginRequired
    /// 로그인 실패
    case loginFailed
    /// 로그아웃 실패
    case logoutFailed
    
    /// 닉네임 설정 실패
    case nicknameSaveFailed
    /// 회원가입 실패
    case signupFailed
    /// 탈퇴 실패
    case signoutFailed
    
   
    case saveFailed
    case editFailed
    case deleteFailed
    
    /// 한계 도달 메세지
    case maxPhotoLimitReached
    
    /// 공감실패
    case likeFailed
    /// 신고 실패
    case reportFailed
    
    /// 필수값 입력 필요
    case requiredSelection
    
    
    

    // MARK: 성공 메시지
    case saveSuccess
    case editSuccess
    case deleteSuccess
    case welcomeMessage(nickname: String)
    

    var text: String {
        switch self {
        // MARK: 에러
        case .unknownRequestFailed, .likeFailed, .reportFailed:
            return "요청을 처리하지 못했어요.\n잠시 후 다시 시도해 주세요."
        case .loginFailed:
            return "로그인에 실패했어요. 다시 시도해 주세요."
        case .logoutFailed:
            return "로그아웃에 실패했어요. 다시 시도해 주세요."
        case .loginRequired:
            return "로그인이 필요해요. 로그인 후 다시 시도해 주세요."
        case .signupFailed:
            return "회원가입에 실패했어요.\n다시 시도해 주세요."
        case .signoutFailed:
            return "탈퇴에 실패했어요. 다시 시도해 주세요."
            

        case .nicknameSaveFailed:
            return "닉네임 설정에 실패했어요. 다시 시도해 주세요."
        case .saveFailed:
            return "저장에 실패했어요.\n다시 시도해 주세요."
        case .editFailed:
            return  "수정에 실패했어요.\n다시 시도해 주세요."
        case .deleteFailed:
            return "삭제에 실패했어요.\n다시 시도해 주세요."
        case .maxPhotoLimitReached: 
            return "기록 한도에 도달했어요.\n로그인하면 계속 기록할 수 있어요."
            
        case .requiredSelection:
            return "필수 항목을 선택해 주세요."

            // MARK: 성공
        case .saveSuccess:
            return "저장이 완료되었어요."
        case .editSuccess:
            return "수정이 완료되었어요."
        case .deleteSuccess:
            return "삭제가 완료되었어요."
        case .welcomeMessage(let nickname):
            return "반가워요, \(nickname)님! 이제 기록을 시작해볼까요?"
        }
    }

    var displayType: MessageDisplayType {
        switch self {
        // 팝업
        case .loginFailed, // 로그인 실패
                .loginRequired, // 로그인 필요
                .maxPhotoLimitReached, // 기록초과
                .signoutFailed: //회원가입 탈퇴
            return .alert

        // 토스트
        default:
            return .toast
        }
    }
}

// MARK: - Message Displayable Protocol

protocol MessageDisplayable: ObservableObject {
    var toastMessage: String? { get set }
    var alertMessage: String? { get set }
}

extension MessageDisplayable {
    func showToast(_ message: String) {
        toastMessage = message
    }

    func showAlert(_ message: String) {
        alertMessage = message
    }

    /// AppMessage를 표시
    func show(_ message: AppMessage) {
        switch message.displayType {
        case .toast:
            showToast(message.text)
        case .alert:
            showAlert(message.text)
        }
    }
}
