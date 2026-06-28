//
//  MainTabRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//


import Foundation

protocol MainTabRepositoryProtocol {
    func getCanReviewOpen() -> Bool
    func setReviewDelayed(days: Int)
}
