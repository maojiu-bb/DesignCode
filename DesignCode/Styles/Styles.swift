//
//  Styles.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/19.
//

import SwiftUI

struct StrokeStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.overlay {
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
            .stroke(
                .linearGradient(
                    colors: [
                        .white.opacity(colorScheme == .dark ? 0.1 : 0.3),
                        .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .blendMode(.overlay)
        }
    }
}

extension View {
    func strokeStyle(cornerRadius: CGFloat = 30.0) -> some View {
        modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}
