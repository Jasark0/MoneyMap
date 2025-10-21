//
//  ProfileView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""

    @State private var showSavedMessage = false
    @State private var navigateToForgotPassword = false
    @State private var navigateToSettings = false

    private let bannerHeight: CGFloat = 84

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Banner
                ZStack(alignment: .leading) {
                    Color("Independence").ignoresSafeArea(edges: .top)
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        Text("Your Profile")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .padding(.top, 8)
                }
                .frame(height: bannerHeight)

                // Content
                ScrollView {
                    VStack(spacing: 36) {
                        InputView(title: "First Name", text: $firstName)
                        InputView(title: "Last Name", text: $lastName)
                        InputView(title: "Username", text: $username)
                        InputView(title: "Email", text: $email)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)

                    // Reset Password button
                    Button(action: {
                        navigateToForgotPassword = true
                    }) {
                        Text("Reset My Password")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Oxford Blue"))
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                    }

                    // Save button
                    Button(action: {
                        withAnimation {
                            showSavedMessage = true
                        }

                        // Simulate saving, then navigate to SettingsView
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSavedMessage = false
                                navigateToSettings = true
                            }
                        }
                    }) {
                        Text("Save")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color("Royal Blue"))
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                }
                .frame(maxWidth: .infinity)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $navigateToForgotPassword) {
                ForgotPasswordView()
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
            .overlay(
                Group {
                    if showSavedMessage {
                        Text("Profile saved successfully!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green.opacity(0.9))
                            .cornerRadius(12)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 30)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
