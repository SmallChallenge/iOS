//
//  View+Extension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import SwiftUI

public struct MainBackgroundColorModified: ViewModifier {
    private var color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            color
            
            content
        }
        .background(color)
    }
}
 extension View {
    func mainBackgourndColor(_ color: Color = .gray900) -> ModifiedContent<Self, MainBackgroundColorModified> {
        modifier(MainBackgroundColorModified(color: color))
    }
}
