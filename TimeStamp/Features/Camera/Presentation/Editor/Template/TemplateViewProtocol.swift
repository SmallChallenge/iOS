//
//  TemplateViewProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import Foundation
import SwiftUI

protocol TemplateViewProtocol: View {
    var displayDate: Date { get }
    var hasLogo: Bool { get }
}
