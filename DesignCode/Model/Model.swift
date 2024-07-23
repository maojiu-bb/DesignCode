//
//  Model.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/20.
//

import SwiftUI
import Combine

class Model: ObservableObject {
    @Published var showDetail: Bool = false
    @Published var selectedModal: Modal = .signIn
    
}

enum Modal: String {
    case signUp
    case signIn
}
