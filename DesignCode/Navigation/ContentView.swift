//
//  ContentView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/19.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @AppStorage("showModal") var showModal = false
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            switch selectedTab {
            case .home:
                HomeView()
            case .explore:
                AccountView()
            case .notifications:
                Text("notifications")
            case .library:
                Text("librarys")
            }
            
            TabBar()
                .offset(y: model.showDetail ? 200 : 0)
            
            if showModal {
                ModalView()
                    .zIndex(1.0)
            }
        }
        .animation(.easeInOut, value: showModal) // 添加动画修饰符
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 44)
        }
    }
}

#Preview {
    ContentView().environmentObject(Model())
}

