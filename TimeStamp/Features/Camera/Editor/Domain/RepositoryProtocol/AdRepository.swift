//
//  AdRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 1/8/26.
//

import Foundation
import UIKit

@MainActor
protocol AdRepositoryProtocol {
    func loadRewardedAd() async throws
    func showRewardedAd(fromRootViewController: UIViewController) async throws -> Int
}
