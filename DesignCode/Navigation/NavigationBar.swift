//
//  NavigationBar.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/20.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var hasScrolled: Bool
    @State var showSearch = false
    @State var showAccount = false
    @AppStorage("showModal") var showModal = false
    @AppStorage("isLogged") var isLogged = false
    var title = ""
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
                .blur(radius: 10)
                .opacity(hasScrolled ? 1 : 0)
            
            Text(title)
                .animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 20)
                .offset(y: hasScrolled ? -4 : 0)
            
            HStack(spacing: 16) {
                Button {
                    showSearch = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.body.weight(.bold))
                        .frame(width: 36, height: 36)
                        .foregroundStyle(.secondary)
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                        )
                        .strokeStyle(cornerRadius: 14)
                }
                .sheet(
                    isPresented: $showSearch,
                    content: {
                        SearchView()
                    }
                )
                
                Button {
                    if isLogged {
                        showAccount = true
                    } else {
                        withAnimation {
                            showModal = true
                        }
                    }
                } label: {
                    AvatarView()
                }
                .sheet(isPresented: $showAccount, content: {
                    AccountView()
                })
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.trailing, 20)
            .padding(.top, 20)
            .offset(y: hasScrolled ? -4 : 0)
        }
        .frame(height: hasScrolled ? 44 : 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationBar(hasScrolled: .constant(false), title: "Featured")
}
