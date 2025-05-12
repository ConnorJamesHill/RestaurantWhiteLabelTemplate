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
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Settings")
        }
    }
    
    // MARK: - Header
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            Image("restaurant_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.2), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
            
            Text("Owner Account")
                .font(.headline)
            
            Text("admin@restaurant.com")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
    
    // MARK: - Sections
    
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
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
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(Color.primary.opacity(0.05))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
    
    private var accountActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Account")
            
            Button(action: {
                viewModel.signOut()
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                        .font(.system(size: 20))
                        .frame(width: 36, height: 36)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                    
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .font(.headline)
                    
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
    
    private var appInfoSection: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Restaurant Manager App")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Version \(appVersion)")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            HStack(spacing: 16) {
                Link(destination: URL(string: "https://terms.example.com")!) {
                    Text("Terms of Service")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .underline()
                }
                
                Link(destination: URL(string: "https://privacy.example.com")!) {
                    Text("Privacy Policy")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .underline()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.bottom, 8)
    }
    
    private func settingsItemLink(title: String, description: String, iconName: String, iconColor: Color) -> some View {
        NavigationLink(destination: Text(title)) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .font(.system(size: 20))
                    .frame(width: 36, height: 36)
                    .background(iconColor.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
