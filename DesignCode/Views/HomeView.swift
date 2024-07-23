//
//  HomeView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/20.
//

import SwiftUI

struct HomeView: View {
    @State var hasScrolled = false
    @Namespace var namespace
    @State var show = false
    @State var showStatusBar = true
    @State var selectedId = UUID()
    @State var showCourse = false
    @State var selectIndex = 0
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            
            ScrollView {
                scrollDetection
                
                featured
                
                Text("Courses".uppercased())
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                
                LazyVGrid(
                    columns: [
                        GridItem(
                            .adaptive(minimum: 300),
                            spacing: 20
                        )
                    ],
                    spacing: 20,
                    content: {
                        cards
                    })
                .padding(.horizontal, 20)
            }
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top, content: {
                Color.clear.frame(height: 70)
            })
            .overlay {
                NavigationBar(hasScrolled: $hasScrolled, title: "Featured")
            }
            
            if show {
                detail
            }
        }
        .statusBar(hidden: !showStatusBar)
        .onChange(of: show) { oldValue, newValue in
            withAnimation(.closeCard) {
                if newValue {
                    showStatusBar = false
                } else {
                    showStatusBar = true
                }
            }
        }
    }
    
    var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: ScrollPreferenceKey.self,
                value: proxy.frame(in: .named("scroll")).minY
            )
        }
        .frame(height: 0)
        .onPreferenceChange(
            ScrollPreferenceKey.self,
            perform: { value in
                withAnimation(.smooth) {
                    if value < 0 {
                        hasScrolled = true
                    } else {
                        hasScrolled = false
                    }
                }
            })
    }
    
    var featured: some View {
        TabView {
            ForEach(Array(featuredCourses.enumerated()), id: \.offset) { index, item in
                GeometryReader { proxy in
                    let minX = proxy.frame(in: .global).minX / 10
                    
                    FeaturedItem(course: item)
                        .frame(maxWidth: 500)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .rotation3DEffect(
                            .degrees(minX),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .shadow(
                            color: Color("Shadow")
                                .opacity(0.3),
                            radius: 10,
                            x: 0,
                            y: 10
                        )
                        .blur(radius: abs(minX / 20))
                        .onTapGesture {
                            showCourse = true
                            selectIndex = index
                        }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 430)
        .background(
            Image("Blob 1")
                .offset(x: 250, y: -100)
        )
        .sheet(isPresented: $showCourse, content: {
            CourseView(namespace: namespace, show: $showCourse, course: featuredCourses[selectIndex])
        })
    }
    
    var cards: some View {
        ForEach(courses) { item in
            CourseItem(namespace: namespace, show: $show, course: item)
                .onTapGesture {
                    withAnimation(.openCard) {
                        show.toggle()
                        model.showDetail.toggle()
                        showStatusBar = false
                        selectedId = item.id
                    }
                }
        }
    }
    
    var detail: some View {
        ForEach(courses) { item in
            if item.id == selectedId {
                CourseView(namespace: namespace, show: $show, course: item)
                    .zIndex(1.0)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                            removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))
                        )
                    )
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Model())
}
