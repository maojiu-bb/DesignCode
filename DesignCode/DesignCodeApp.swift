//
//  DesignCodeApp.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/19.
//

import SwiftUI
import SwiftData

@main
struct DesignCodeApp: App {
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
