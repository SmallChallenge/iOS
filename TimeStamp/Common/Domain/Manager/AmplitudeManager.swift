//
//  AmplitudeManager.swift
//  Stampic
//
//  Created by 임주희 on 1/6/26.
//

import Foundation
import AmplitudeSwift
import AppTrackingTransparency


final class AmplitudeManager {
    static let shared = AmplitudeManager()
    private init(){}
    private var instance: Amplitude?

    private var AMPLITUDE_API_KEY: String {
        guard let apiKey = Bundle.main.infoDictionary?["AMPLITUDE_API_KEY"] as? String else {
            Logger.error("AMPLITUDE_API_KEY를 찾을 수 없습니다")
            return ""
        }
        return apiKey
    }

    /// Production 환경인지 확인 (Release 빌드)
    private var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }

    func loadAmplitude() {
        guard isProduction else {
            return
        }

        let amplitude = Amplitude(
            configuration: Configuration(
                apiKey: AMPLITUDE_API_KEY,
            )
        )
        self.instance = amplitude
    }
}
extension AmplitudeManager {
    enum AmpliEvent: String {
        /// 로그인
        case login = "login_success"
        
        /// 로그아웃
        case logout = "logout_success"
        
        /// 카메라 화면 진입
        case enterCameraView = "photo_view_enter"
        
        /// 사진 저장완료 (서버에 저장한 경우에만)
        case photoSaveCompleted = "photo_save_complete"
        
        /// 전체공개로 업로드
        case photoUploadToPublic = "post_create_complete"
        
        /// 커뮤니티 화면 진입
        case enterCommunityView = "community_view_enter"
        
        var name: String {
            self.rawValue
        }
    }
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version)(\(build))"
    }
    
    private var commonProperties: [String: Any]? {
        [
            "is_logged_in" : AuthManager.shared.isLoggedIn,
            "platform":"ios",
            "app_version" : appVersion
        ]
    }
    
    
    /// 공통으로 사용할 이벤트 트래킹 메서드, 모든 이벤트가 이걸 사용해서 보내야함.
    private func eventTrack(_ event: AmpliEvent, eventProperties: [String: Any]? = nil){
        guard isProduction else { // 운영에서만 보내기
            return
        }
        
        // commonProperties와 merge
        var mergedProperties = commonProperties ?? [:]

        // eventProperties가 있으면 merge (eventProperties가 우선)
        if let eventProperties = eventProperties {
            mergedProperties.merge(eventProperties) { (_, new) in new }
        }
       
        // Amplitude 인스턴스 확인 및 초기화
        if instance == nil {
            Logger.warning("Amplitude 인스턴스가 초기화되지 않음 - 즉시 초기화 시도")
            loadAmplitude()
        }

        // 초기화 후에도 instance가 없으면 실패
        guard let instance = instance else {
            Logger.error("Amplitude 초기화 실패 - 이벤트 전송 불가: \(event.name)")
            return
        }

        // 이벤트 전송 (Production only)
        instance.track(
            eventType: event.name,
            eventProperties: mergedProperties
        )

        // 성공 로그
        Logger.debug("Amplitude 이벤트 전송: \(event.name)")
    }
    
    // MARK: - 이벤트 -
    
    /// Amplitude userId 설정 (로그인 이벤트 없이)
    func setUserId(_ userId: Int?) {
        guard isProduction else {
            return
        }
        
        let userIdString = userId.map { "user_\($0)" }
        instance?.setUserId(userId: userIdString)
    }

    func login(userId: Int, socialType: LoginType){
        // userId 설정
        setUserId(userId)

        // 로그인 이벤트 전송 (eventTrack 내부에서 초기화 확인)
        eventTrack(.login, eventProperties: [
            "login_method" : socialType.rawValue
        ])
    }

    func logout(){
        eventTrack(.logout)
        instance?.setUserId(userId: nil)
    }
    
    /// 카메라 화면 진입
    func trackCameraViewEnter(){
        eventTrack(.enterCameraView)
    }
    
    /// 사진 저장 완료 (서버에만)
    func trackCompletePhotoSave(category: Category, visibility: VisibilityType){
        eventTrack(.photoSaveCompleted, eventProperties: [
            "category" : category.rawValue.lowercased(),
            "save_scope": visibility.rawValue.lowercased()
        ])
    }

    /// 전체공개로 사진 업로드 or 전체공개로 사진을 수정한 경우
    func trackPublicPhotoUpload(category: Category){
        eventTrack(.photoUploadToPublic, eventProperties: [
            "category" : category.rawValue.lowercased()
        ])
    }
    
    /// 커뮤니티 화면 진입
    func trackCommunityViewEnter(){
        eventTrack(.enterCommunityView)
    }
}
