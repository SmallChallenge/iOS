//
//  NicknameSettingViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation
import Combine

class NicknameSettingViewModel: ObservableObject {
    
    private let useCase: NicknameSettingUseCaseProtocol
    init(useCase: NicknameSettingUseCaseProtocol) {
        self.useCase = useCase
    }
    
    
    // Output Property
    @Published var isLoading = false
    @Published var validateMessage: String? = nil
    
    /// 저장 성공 여부
    @Published var isSaved = false
    
    // Input Method
    func checkValidateNickname(_ nickname: String) -> Bool {

        // 공백 체크
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespaces)

        // 2자 미만, 10자 초과
        if trimmedNickname.count < 2 || trimmedNickname.count > 10 {
            validateMessage = "닉네임은 2~10자로 입력해주세요."
            return false
        }

        // 특수문자 포함 체크 (한글, 영문, 숫자만 허용)
        let pattern = "^[가-힣a-zA-Z0-9]+$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: trimmedNickname.utf16.count)

        if regex?.firstMatch(in: trimmedNickname, range: range) == nil {
            validateMessage = "닉네임은 공백 없이 한글, 영문, 숫자만 가능해요."
            return false
        }

        validateMessage = nil
        return true
    }
    
    /// 닉네임 저장하기
    func saveNickname(_ nickname: String) {
        guard checkValidateNickname(nickname) && !isLoading else { return }

        Task {
            await MainActor.run { isLoading = true }
            Logger.debug("닉네임 저장하기: \(nickname)")

            do {
                let result = try await useCase.setNickname(nickname: nickname)
                await MainActor.run {
                    isLoading = false
                    isSaved = true
                    ToastManager.shared.show(AppMessage.welcomeMessage(nickname: nickname).text)
                    Logger.success("닉네임 설정 완료: \(result.nickname)")
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    isLoading = false
                    // 서버 에러 code별 처리
                    switch error {
                    case .serverFailed(let code, let message):
                        if code == "NICKNAME_ALREADY_EXISTS" {
                            validateMessage = "이미 누군가 사용하고 있어요."
                        }
                        Logger.error("닉네임 설정 실패 [\(code)]: \(message)")
                    default:
                        validateMessage = error.description
                        Logger.error("닉네임 설정 실패: \(error)")
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    validateMessage = error.localizedDescription
                    Logger.error("닉네임 설정 실패: \(error)")
                }
            }
        }
    }
}
