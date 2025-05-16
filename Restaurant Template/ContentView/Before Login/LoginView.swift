//
//  LoginView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/7/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = LoginViewViewModel()
    @State private var showingRegister = false
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
                
                VStack(spacing: 30) {
                    // Logo
                    VStack(spacing: 20) {
                        Image("restaurant_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.top, 50)
                        
                        Text(restaurant.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textColor)
                        
                        Text("Welcome Back")
                            .font(.title2)
                            .foregroundColor(themeManager.textColor.opacity(0.8))
                    }
                    
                    // Login Form
                    VStack(spacing: 20) {
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.horizontal)
                        }
                        
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .foregroundColor(themeManager.currentTheme == .light ? .black : themeManager.textColor)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(themeManager.currentTheme == .light ? .black : themeManager.textColor)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("Log In")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(themeManager.primaryColor.opacity(0.2))
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
                        }
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
                    
                    // Register Link
                    VStack(spacing: 12) {
                        Text("New to \(restaurant.name)?")
                            .foregroundColor(themeManager.textColor.opacity(0.8))
                        
                        Button("Create an Account") {
                            showingRegister = true
                        }
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(themeManager.primaryColor.opacity(0.2))
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
                    }
                    .padding(.bottom, 30)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingRegister) {
                RegisterView()
                    .environmentObject(themeManager)
            }
        }
    }
}
