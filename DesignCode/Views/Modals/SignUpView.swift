//
//  SignUpView.swift
//  DesignCode
//
//  Created by 钟钰 on 2024/7/22.
//

import SwiftUI

struct SignUpView: View {
    enum Field: Hashable {
        case email
        case password
    }
    
    @State var email = ""
    @State var password = ""
    @FocusState var focusedField: Field?
    @State var circleY: CGFloat = 0
    @State var emailY: CGFloat = 0
    @State var passwordY: CGFloat = 0
    @State var circleColor: Color = .blue
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sign up")
                .font(.largeTitle)
                .bold()
            Text("Access 120+ hours of courses, tutorial and livestreams")
                .font(.headline)
            
            TextField("Email", text: $email)
                .inputStyle(icon: "mail")
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)
                .focused($focusedField, equals: .email)
                .shadow(
                    color: focusedField == .email ? .primary.opacity(0.3) : .clear,
                    radius: 10,
                    x: 0,
                    y: 3
                )
                .overlay {
                    geometry
                }
                .onPreferenceChange(
                    CirclePreferenceKey.self) { value in
                        emailY = value
                        circleY = value
                    }
            SecureField("Password", text: $password)
                .inputStyle(icon: "lock")
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .shadow(
                    color: focusedField == .password ? .primary.opacity(0.3) : .clear,
                    radius: 10,
                    x: 0,
                    y: 3
                )
                .overlay {
                    geometry
                }
                .onPreferenceChange(
                    CirclePreferenceKey.self) { value in
                        passwordY = value
                        circleY = value
                    }
            
            Button {
                
            } label: {
                Text("Create an account")
                    .frame(maxWidth: .infinity)
            }
            .font(.headline)
            .blendMode(.overlay)
            .buttonStyle(.angular)
            .tint(.accentColor)
            .controlSize(.large)
            .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
            
            Group {
                Text("By clicking on ")
                + Text("_Create an account_").foregroundStyle(.primary.opacity(0.7))
                + Text(", you agree to our **Terms of Service** and **[Privice Policy](https://designcode.io)**")
                
                Divider()
                
                HStack {
                    Text("Already have an account?")
                    Button {
                        model.selectedModal = .signIn
                    } label: {
                        Text("**Sign in**")
                    }
                }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .tint(.secondary)
        }
        .padding(20)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .background(
            Circle()
                .fill(circleColor)
                .frame(width: 68, height: 68)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(y: circleY)
        )
        .coordinateSpace(name: "container")
        .strokeStyle(cornerRadius: 30)
        .onChange(of: focusedField) { oldValue, newValue in
            withAnimation {
                if newValue == .email {
                    circleY = emailY
                    circleColor = .blue
                } else {
                    circleY = passwordY
                    circleColor = .red
                }
            }
        }
    }
    
    var geometry: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: CirclePreferenceKey.self,
                value: proxy.frame(in: .named("container")).minY
            )
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(Model())
}