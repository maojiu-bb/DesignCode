//
//  AccountView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/19.
//

import SwiftUI

struct AccountView: View {
    @State var isDeleted = false
    @State var isPined = false
    @State var address: Address = Address(city: "China")
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLogged") var isLogged = false
    @ObservedObject var coinModel = CoinModel()
    
    func fetchAddress() async {
        do {
            let url = URL(string: "https://www.mocklib.com/mock/random/city")!
            let (data, _) = try await URLSession.shared.data(from: url)
            address = try JSONDecoder().decode(Address.self, from: data)
        } catch {
            address = Address(city: "Error fetching")
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                profile
                
                menu
                
                links
                
                coins
                
                Button {
                    isLogged = false
                    dismiss()
                } label: {
                    Text("Sign out")
                }
                .tint(.red)
            }
            .task {
                await fetchAddress()
                await coinModel.fetchCoins()
            }
            .refreshable {
                await fetchAddress()
                await coinModel.fetchCoins()
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Account")
            .toolbar(content: {
                Button {
                    dismiss()
                } label: {
                    Text("Done").bold()
                }
            })
            
        }
    }
    
    var profile: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .symbolVariant(.circle.fill)
                .font(.system(size: 32))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .blue.opacity(0.3))
                .padding()
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                )
                .background(
                    HexagonView()
                        .offset(x: -50, y: -100)
                )
                .background(
                    BlobView()
                        .offset(x: 200, y: 0)
                        .scaleEffect(0.6)
                )
            Text("Mao Jiu")
                .font(.title.weight(.semibold))
            HStack {
                Image(systemName: "location")
                    .imageScale(.large)
                Text(address.city)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    
    var menu: some View {
        Section {
            NavigationLink {
                HomeView()
            } label: {
                Label("Settings", systemImage: "gear")
            }
            NavigationLink {
                Text("Billing")
            } label: {
                Label("Billing", systemImage: "creditcard")
            }
            NavigationLink {
                HomeView()
            } label: {
                Label("Help", systemImage: "questionmark")
                    .imageScale(.small)
            }
        }
        .foregroundStyle(.primary)
        .listRowSeparatorTint(.blue)
        .listRowSeparator(.hidden)
    }
    
    
    var links: some View {
        Section {
            if !isDeleted {
                Link(
                    destination: URL(string: "https://www.apple.com")!,
                    label: {
                        HStack {
                            Label("Apple", systemImage: "apple.logo")
                            Spacer()
                            Image(systemName: "link")
                                .foregroundStyle(.secondary)
                        }
                    }
                )
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button {
                        isDeleted = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                    
                    pinButton
                }
            }
            Link(
                destination: URL(string: "https:/youtube.com")!,
                label: {
                    HStack {
                        Label("YouTube", systemImage: "tv")
                        Spacer()
                        Image(systemName: "link")
                            .foregroundStyle(.secondary)
                    }
                }
            )
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button {
                    isDeleted = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(.red)
                
                pinButton
            }
        }
        .foregroundStyle(.primary)
        .listRowSeparator(.hidden)
    }
    
    var coins: some View {
        Section(content: {
            ForEach(coinModel.coins) { item in
                HStack {
                    AsyncImage(url: URL(string: item.logo)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 32, height: 32)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.coin_name)
                        Text(item.acronym)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }, header: {
            Text("Coins")
        })
    }
    
    var pinButton: some View {
        Button {
            isPined.toggle()
        } label: {
            if isPined {
                Label("Unpin", systemImage: "pin.slash")
            } else {
                Label("Pin", systemImage: "pin")
            }
        }
        .tint(isPined ? .gray : .yellow)
    }
}



#Preview {
    AccountView()
        .environmentObject(CoinModel())
}
