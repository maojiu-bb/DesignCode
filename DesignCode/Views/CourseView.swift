//
//  CourseView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/20.
//

import SwiftUI

struct CourseView: View {
    var namespace: Namespace.ID
    @Binding var show: Bool
    @State var appear = [false, false, false]
    var course: Course = courses[0]
    @EnvironmentObject var model: Model
    @State var viewState: CGSize = .zero
    @State var isDraggable = true
    
    var body: some View {
        ZStack {
            ScrollView {
                cover
                
                content
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
                model.showDetail = true
            }
            .onDisappear {
                model.showDetail = false
            }
            .background(Color("Background"))
            .mask({
                RoundedRectangle(cornerRadius: 30, style: .continuous)
            })
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            .scaleEffect(viewState.width / -500 + 1)
            .background(.black.opacity(viewState.width / 500))
            .background(.ultraThinMaterial)
            .gesture(
                isDraggable ? drag : nil
            )
            .ignoresSafeArea()
            
            button
        }
        .onAppear {
            fadeIn()
        }
        .onChange(of: show) { oldValue, newValue in
            fadeOut()
        }
    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                guard value.translation.width > 0
                else { return }
                if value.startLocation.x < 100 {
                    withAnimation(.closeCard) {
                        viewState = value.translation
                    }
                }
                
                if viewState.width > 120 {
                    close()
                }
            }
            .onEnded { value in
                if viewState.width > 80 {
                    close()
                } else {
                    withAnimation(.closeCard) {
                        viewState = .zero
                    }
                }
            }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("SwiftUI is hands-down the best way for designers to take a first step into code.")
                .font(.title3.weight(.medium))
            Text("This course")
                .font(.title.bold())
            Text("This course is unlike any other.")
            Text("This year, SwiftUI got major upgrades from the WWDC 2020.")
            Text("Multiplatform app")
                .font(.title.bold())
            Text("For the first time, you can build entise apps using SwiftUI only.")
        }
        .padding(20)
        .offset(y: 120)
        .padding(.bottom, 200)
        .opacity(appear[2] ? 1 : 0)
    }
    
    var button: some View {
        Button {
            withAnimation(.closeCard) {
                show.toggle()
                model.showDetail.toggle()
            }
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
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topTrailing
        )
        .padding(20)
        .ignoresSafeArea()
    }
    
    
    var cover: some View {
        GeometryReader { proxy in
            let scrollY = proxy.frame(in: .named("scroll")).minY
            
            VStack {
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: scrollY > 0 ? 500 + scrollY : 500)
            .foregroundStyle(.black)
            .background(
                Image(course.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(20)
                    .frame(maxWidth: 500)
                    .matchedGeometryEffect(id: "image\(course.id)", in: namespace)
                    .offset(y: scrollY > 0 ? scrollY * -0.8 : 0)
            )
            .background(
                Image(course.background)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .matchedGeometryEffect(id: "background\(course.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
                    .scaleEffect(scrollY > 0  ? scrollY / 1000  + 1 : 1)
                    .blur(radius: scrollY / 50)
            )
            .mask {
                RoundedRectangle(cornerRadius: appear[0] ? 0 : 30, style: .continuous)
                    .matchedGeometryEffect(id: "mask\(course.id)", in: namespace)
                    .offset(y: scrollY > 0 ? -scrollY : 0)
            }
            .overlay {
                overlayContent
                    .offset(y: scrollY > 0 ? scrollY * -0.6 : 0)
            }
        }
        .frame(height: 500)
    }
    
    var overlayContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(course.title)
                .font(.largeTitle.weight(.bold))
                .matchedGeometryEffect(id: "title\(course.id)", in: namespace)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(course.subtitle.uppercased())
                .font(.footnote.weight(.semibold))
                .matchedGeometryEffect(id: "subtitle\(course.id)", in: namespace)
            Text(course.text)
                .font(.footnote)
                .matchedGeometryEffect(id: "text\(course.id)", in: namespace)
            Divider()
                .opacity(appear[0] ? 1 : 0)
            HStack {
                Image("Avatar Default")
                    .resizable()
                    .frame(width: 26, height: 26)
                    .clipShape(Circle())
                    .padding(8)
                    .background(
                        .ultraThinMaterial,
                        in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                    )
                    .strokeStyle(cornerRadius: 18)
                Text("Taught by MaoJiu")
                    .font(.footnote)
            }
            .opacity(appear[0] ? 1 : 0)
        }
        .padding(20)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask {
                    RoundedRectangle(
                        cornerRadius: 30,
                        style: .continuous
                    )
                }
                .matchedGeometryEffect(id: "blur\(course.id)", in: namespace)
        }
        .offset(y: 250)
        .padding(20)
    }
    
    func fadeIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            appear[0] = true
        }
        withAnimation(.easeInOut(duration: 0.4)) {
            appear[1] = true
        }
        withAnimation(.easeInOut(duration: 0.5)) {
            appear[2] = true
        }
    }
    
    func fadeOut() {
        appear[0] = false
        appear[1] = false
        appear[2] = false
    }
    
    func close() {
        withAnimation(.closeCard.delay(0.3)) {
            show.toggle()
            model.showDetail.toggle()
        }
        
        withAnimation(.closeCard) {
            viewState = .zero
        }
        isDraggable = false
    }
}

#Preview {
    @Namespace var namespace
    
    return CourseView(namespace: namespace, show: .constant(true))
        .environmentObject(Model())
}
