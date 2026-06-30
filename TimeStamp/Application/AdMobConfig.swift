//
//  AdMobConfig.swift
//  TimeStamp
//
//  Created by 임주희 on 6/30/26.
//


// MARK: - google admob  SDK key
    enum AdMobConfig {
    #if DEBUG
    static let ad_banner = "ca-app-pub-3940256099942544/2435281174"
    static let ad_reward = "ca-app-pub-3940256099942544/1712485313"
    #else
    static let ad_banner = "ca-app-pub-7896890737820919/2318652866"
    static let ad_reward = "ca-app-pub-7896890737820919/7532361228"
    #endif
}