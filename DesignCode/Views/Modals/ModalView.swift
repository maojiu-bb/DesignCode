//
//  ModalView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/22.
//

import SwiftUI

struct ModalView: View {
    @EnvironmentObject var model: Model
    @AppStorage("showModal") var showModal = true
    @State var viewState: CGSize = .zero
    @State var isDismissed = false
    @State var appear = [false, false, false]
    @AppStorage("isLogged") var isLogged = false
    
    var body: some View {
        ZStack {
            Color.clear.background(.regularMaterial)
                .onTapGesture {
                    dismissModal()
                }
                .ignoresSafeArea()
                .transition(.opacity) // 添加过渡动画
            
            Group {
                switch model.selectedModal {
                case .signUp:
                    SignUpView()
                case .signIn:
                    SignInView()
                }
            }
            .mask({
                RoundedRectangle(cornerRadius: 30, style: .continuous)
            })
            .offset(x: viewState.width, y: viewState.height)
            .offset(y: isDismissed ? 1000 : 0)
            .rotationEffect(.degrees(viewState.width / 40))
            .rotation3DEffect(
                .degrees(viewState.height / 20),
                axis: (x: 1, y: 0, z: 0)
            )
            .hueRotation(.degrees(viewState.width / 5))
            .gesture(drag)
            .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
            .opacity(appear[0] ? 1 : 0)
            .offset(y: appear[0] ? 0 : 200)
            .padding(20)
            .background(
                Image("Blob 1")
                    .offset(x: 200, y: -100)
                    .allowsTightening(false)
                    .opacity(appear[0] ? 1 : 0)
                    .offset(y: appear[0] ? 0 : 10)
                    .blur(radius: appear[2] ? 0 : 40)
            )
            
            Button {
                dismissModal()
            } label: {
                Image(systemName: "xmark")
                    .font(.body.weight(.bold))
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(
                        .ultraThinMaterial,
                        in: Circle()
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(20)
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : -200)

        }
        .onAppear {
            withAnimation(.easeInOut) {
                appear[0] = true
            }
            withAnimation(.easeInOut.delay(0.1)) {
                appear[1] = true
            }
            withAnimation(.easeInOut(duration: 1).delay(0.2)) {
                appear[2] = true
            }
        }
        .onChange(of: isLogged) { oldValue, newValue in
            if newValue {
                dismissModal()
            }
        }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                viewState = value.translation
            }
            .onEnded { value in
                if value.translation.height > 200 {
                    dismissModal()
                } else {
                    withAnimation(.openCard) {
                        viewState = .zero
                    }
                }
            }
    }
    
    func dismissModal() {
        withAnimation {
            isDismissed = true
        }
        withAnimation(.linear.delay(0.3)) {
            showModal = false
        }
    }
}

#Preview {
    ModalView()
        .environmentObject(Model())
}