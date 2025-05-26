//
//  RegisterView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/7/25.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = RegisterViewViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient from ThemeManager
                themeManager.backgroundGradient
                    .ignoresSafeArea()
                
                // Decorative elements
                Circle()
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 30)
                    .offset(x: -150, y: -100)
                
                Circle()
                    .fill(Color.black.opacity(0.08))
                    .frame(width: 250, height: 250)
                    .blur(radius: 20)
                    .offset(x: 180, y: 400)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        Text("Create Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.top, 50)
                        
                        // Registration Form
                        VStack(spacing: 20) {
                            if !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                    .padding(.horizontal)
                            }
                            
                            ZStack(alignment: .leading) {
                                TextField("", text: $viewModel.name)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .autocapitalization(.words)
                                
                                if viewModel.name.isEmpty {
                                    Text("Full Name")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(10)
                                        .allowsHitTesting(false)
                                }
                            }
                            .padding(.horizontal)
                            
                            ZStack(alignment: .leading) {
                                TextField("", text: $viewModel.email)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                
                                if viewModel.email.isEmpty {
                                    Text("Email Address")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(10)
                                        .allowsHitTesting(false)
                                }
                            }
                            .padding(.horizontal)
                            
                            ZStack(alignment: .leading) {
                                SecureField("", text: $viewModel.password)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                
                                if viewModel.password.isEmpty {
                                    Text("Password")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(10)
                                        .allowsHitTesting(false)
                                }
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                isLoading = true
                                viewModel.register()
                            }) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: themeManager.textColor))
                                } else {
                                    Text("Create Account")
                                }
                            }
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.primaryColor.opacity(viewModel.isFormValid ? 0.9 : 0.2))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 0.15
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .disabled(isLoading || !viewModel.isFormValid)
                            .padding(.horizontal)
                            
                            Text("Or")
                                .foregroundColor(themeManager.textColor.opacity(0.8))
                                .padding(.vertical, 8)
                            
                            Button(action: {
                                isLoading = true
                                viewModel.guestRegister()
                            }) {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: themeManager.textColor))
                                } else {
                                    Text("Continue as Guest")
                                }
                            }
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.primaryColor.opacity(0.8))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 0.15
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                            .disabled(isLoading)
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 30)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.15
                                )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
        }
    }
}
