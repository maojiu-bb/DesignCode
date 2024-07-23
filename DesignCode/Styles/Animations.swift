//
//  Animations.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/20.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.9)
}
