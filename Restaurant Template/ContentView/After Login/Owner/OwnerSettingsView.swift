//
//  OwnerSettingsView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import Foundation
import SwiftUI

struct OwnerSettingsView: View {
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    @State private var appVersion = "1.0.0"
    @Environment(\.colorScheme) private var colorScheme
    
    // Blue gradient background - matching other owner views
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"), // Vibrant blue
                Color(hex: "0d47a1"), // Deep blue
                Color(hex: "002171"), // Dark blue
                Color(hex: "002984")  // Navy blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
                    .ignoresSafeArea()
                
                // Decorative elements
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 30)
                    .offset(x: -150, y: -100)
                
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 250, height: 250)
                    .blur(radius: 20)
                    .offset(x: 180, y: 400)
                
                ScrollView {
                    VStack(spacing: 20) {
                        profileHeader
                        
                        // Restaurant Profile
                        restaurantProfileSection
                        
                        // Staff Management
                        staffManagementSection
                        
                        // System Settings
                        systemSection
                        
                        // Account Actions
                        accountActionsSection
                        
                        // App Info
                        appInfoSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            Image("restaurant_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            Text("Owner Account")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("admin@restaurant.com")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal)
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var restaurantProfileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Restaurant Profile")
            
            settingsItemLink(
                title: "Restaurant Information",
                description: "Edit name, cuisine, description",
                iconName: "building.2",
                iconColor: .blue
            )
            
            settingsItemLink(
                title: "Business Hours",
                description: "Set open & close times",
                iconName: "clock",
                iconColor: .orange
            )
            
            settingsItemLink(
                title: "Location",
                description: "Address and map settings",
                iconName: "mappin.and.ellipse",
                iconColor: .red
            )
        }
        .padding()
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var staffManagementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Staff Management")
            
            settingsItemLink(
                title: "Staff Accounts",
                description: "Manage staff profiles",
                iconName: "person.3",
                iconColor: .green
            )
            
            settingsItemLink(
                title: "Permissions",
                description: "Access control settings",
                iconName: "lock.shield",
                iconColor: .purple
            )
            
            Button {
                // Add new staff
            } label: {
                HStack {
                    Spacer()
                    Label("Add Staff Member", systemImage: "person.badge.plus")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.top, 8)
        }
        .padding()
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var systemSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("System")
            
            settingsItemLink(
                title: "Payment Settings",
                description: "Manage payment methods",
                iconName: "creditcard",
                iconColor: .purple
            )
            
            settingsItemLink(
                title: "Notification Settings",
                description: "Configure alerts & reminders",
                iconName: "bell.badge",
                iconColor: .blue
            )
            
            settingsItemLink(
                title: "App Settings",
                description: "Theme and preferences",
                iconName: "gear",
                iconColor: .gray
            )
        }
        .padding()
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var accountActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Account")
            
            Button(action: {
                viewModel.signOut()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(Color.red.opacity(0.3))
                        .clipShape(Circle())
                    
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [.black.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
                .shadow(color: Color.red.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var appInfoSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Restaurant Manager App")
                .font(.caption)
                .foregroundColor(.white)
            
            Text("Version \(appVersion)")
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
            
            HStack(spacing: 16) {
                Link(destination: URL(string: "https://terms.example.com")!) {
                    Text("Terms of Service")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .underline()
                }
                
                Link(destination: URL(string: "https://privacy.example.com")!) {
                    Text("Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .underline()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.bottom, 8)
    }
    
    private func settingsItemLink(title: String, description: String, iconName: String, iconColor: Color) -> some View {
        NavigationLink(destination: Text(title)) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(iconColor.opacity(0.3))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.black.opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: iconColor.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
