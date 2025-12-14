//
//  StringExtension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/13/25.
//

import Foundation

extension String {
    var trim: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
}
