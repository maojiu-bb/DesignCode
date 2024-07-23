//
//  AngularButtonStyle.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/22.
//

import SwiftUI

struct AngularButtonStyle: ButtonStyle {
    @Environment(\.controlSize) var controlSize
    
    var extraPadding: CGFloat {
        switch controlSize {
        case .mini:
            return 0
        case .small:
            return 0
        case .regular:
            return 4
        case .large:
            return 12
        case .extraLarge:
            return 16
        @unknown default:
            return 0
        }
    }
    
    var cornerRadius: CGFloat {
        switch controlSize {
        case .mini:
            return 12
        case .small:
            return 12
        case .regular:
            return 16
        case .large:
            return 20
        case .extraLarge:
            return 24
        @unknown default:
            return 12
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 10 + extraPadding)
            .padding(.vertical, 4 + extraPadding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        .linearGradient(
                            colors: [Color(.systemBackground), Color(.systemBackground).opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blendMode(.softLight)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        .angularGradient(
                            colors: [.pink, .purple, .blue, .pink],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        )
                    )
                    .blur(radius: cornerRadius)
            )
            .cornerRadius(cornerRadius)
            .strokeStyle(cornerRadius: cornerRadius)
    }
}


extension ButtonStyle where Self == AngularButtonStyle {
    static var angular: Self {
        return .init()
    }
}
