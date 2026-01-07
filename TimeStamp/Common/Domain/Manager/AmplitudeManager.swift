//
//  AmplitudeManager.swift
//  Stampic
//
//  Created by 임주희 on 1/6/26.
//

import Foundation
import AmplitudeSwift


final class AmplitudeManager {
    static let shared = AmplitudeManager()
    private init(){}
    private var instance: Amplitude?
    
    private let AMPLITUDE_API_KEY = "1f0951318fc0d23dea1fae935c017be9"
    
    func loadAmplitude() {
        Logger.debug("loadAmplitude")
        let amplitude = Amplitude(configuration: Configuration(
            apiKey: AMPLITUDE_API_KEY,
            autocapture: .sessions
        ))
        self.instance = amplitude
    }
}
extension AmplitudeManager {
    enum AmpliEvent: String {
        case login = "login_success"
        case logout = "logout_success"
        
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
    
    private func eventTrack(_ event: AmpliEvent, eventProperties: [String: Any]? = nil){
        var eventProperties = eventProperties
        eventProperties?.merge(commonProperties ?? [:]) { (current, _) in current }
        instance?.track(
            eventType: event.name,
            eventProperties: eventProperties
        )
        print(">>>>> event: \(event.name), eventProperties:\(eventProperties)")
    }
    
    // MARK: - -
    
    func login(userId: Int, socialType: LoginType){
        instance?.setUserId(userId: "\(userId)")
        eventTrack(.login, eventProperties: [
            "login_method" : socialType.rawValue
        ])
        
    }
    
    func logout(){
        eventTrack(.logout)
        instance?.reset()
    }
}
