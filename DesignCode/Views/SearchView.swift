//
//  SearchView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/22.
//

import SwiftUI

struct SearchView: View {
    @State var text = ""
    @State var show = false
    @Namespace var namespace
    @State var selectIndex = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    content
                }
                .padding(20)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 30, style: .continuous)
                )
                .strokeStyle(cornerRadius: 30)
                .padding(20)
            }
            .background(
                Image("Blob 1")
                    .offset(x: 100, y: -200)
            )
            .searchable(
                text: $text,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Text("SwiftUI, React, UI Design")
//                suggestions: {
//                    ForEach(suggestions) { suggestion in
//                        Button {
//                            text = suggestion.text
//                        } label: {
//                            Text(suggestion.text)
//                        }
//                        .searchCompletion(suggestion.text)
//                    }
//                }
            )
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button {
                    dismiss()
                } label: {
                    Text("Done").bold()
                }
            })
            .sheet(isPresented: $show, content: {
                CourseView(namespace: namespace, show: $show, course: courses[selectIndex])
            })
        }
    }
    
    var content: some View {
        ForEach(Array(courses.enumerated()), id: \.offset) { index, item in
            if item.title.contains(text) || text.isEmpty {
                if index != 0 {
                    Divider()
                }
                Button {
                    show = true
                    selectIndex = index
                } label : {
                    HStack(alignment: .top, spacing: 12) {
                        Image(item.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 44, height: 44)
                            .background(Color("Background"))
                            .mask {
                                Circle()
                            }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .bold()
                                .foregroundStyle(.primary)
                            Text(item.text)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .padding(.vertical ,4)
                    .listRowSeparator(.hidden)
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
