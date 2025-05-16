//
//  OwnerSettingsView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/12/25.
//

import SwiftUI

struct OwnerSettingsView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = OwnerSettingsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile header
                profileHeader
                
                // Restaurant Profile
                restaurantProfileSection
                
                // Staff Management
                staffManagementSection
                
                // System Settings
                systemSection
                
                // Theme Selection
                themeSelectionSection
                
                // Account Actions
                accountActionsSection
                
                // App Info
                appInfoSection
            }
            .padding()
        }
    }
    
    // MARK: - Profile Header
    var profileHeader: some View {
        VStack(spacing: 16) {
            Image("restaurant_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(themeManager.primaryColor, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 4) {
                Text(restaurant.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.textColor)
                
                Text("Owner Account")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
            }
            
            GlassButton(title: "Edit Profile", icon: "pencil", action: {
                // Edit profile action
            })
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Restaurant Profile Section
    var restaurantProfileSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Restaurant Profile", icon: "building.2")
            
            VStack(spacing: 16) {
                InfoField(label: "Restaurant Name", value: restaurant.name)
                InfoField(label: "Phone Number", value: restaurant.phoneNumber)
                InfoField(label: "Email", value: restaurant.emailAddress)
                InfoField(label: "Website", value: restaurant.websiteURL)
                InfoField(label: "Address", value: restaurant.address)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            GlassButton(title: "Edit Restaurant Info", icon: "pencil", action: {
                // Edit restaurant info action
            })
        }
    }
    
    // MARK: - Staff Management Section
    var staffManagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Staff Management", icon: "person.3")
            
            VStack(spacing: 0) {
                ForEach(viewModel.staffMembers) { staff in
                    StaffMemberRow(staff: staff)
                    
                    if staff.id != viewModel.staffMembers.last?.id {
                        Divider()
                            .background(themeManager.textColor.opacity(0.2))
                            .padding(.leading, 56)
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            GlassButton(title: "Add Staff Member", icon: "person.badge.plus", action: {
                // Add staff member action
            })
        }
    }
    
    // MARK: - System Settings Section
    var systemSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "System Settings", icon: "gearshape.2")
            
            VStack(spacing: 0) {
                ToggleSetting(title: "Push Notifications", description: "Receive alerts for new orders and reservations", isOn: $viewModel.pushNotificationsEnabled)
                
                Divider()
                    .background(themeManager.textColor.opacity(0.2))
                    .padding(.leading, 56)
                
                ToggleSetting(title: "Email Notifications", description: "Receive daily and weekly reports via email", isOn: $viewModel.emailNotificationsEnabled)
                
                Divider()
                    .background(themeManager.textColor.opacity(0.2))
                    .padding(.leading, 56)
                
                ToggleSetting(title: "Sound Alerts", description: "Play sound for new orders and messages", isOn: $viewModel.soundAlertsEnabled)
                
                Divider()
                    .background(themeManager.textColor.opacity(0.2))
                    .padding(.leading, 56)
                
                ToggleSetting(title: "Auto Updates", description: "Automatically update menu prices across platforms", isOn: $viewModel.autoUpdatesEnabled)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - Theme Selection Section
    var themeSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Theme", icon: "paintbrush")
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Select a theme for your restaurant app")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
                    .padding(.horizontal)
                
                // Theme grid
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 16)
                ], spacing: 16) {
                    ForEach(ThemeManager.AppTheme.allCases) { theme in
                        ThemeOption(theme: theme, isSelected: themeManager.currentTheme == theme)
                            .onTapGesture {
                                themeManager.currentTheme = theme
                            }
                    }
                }
                .padding()
            }
            .padding(.vertical)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    // MARK: - Account Actions Section
    var accountActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Account Actions", icon: "lock.shield")
            
            VStack(spacing: 16) {
                ActionButton(title: "Change Password", icon: "key", color: themeManager.primaryColor) {
                    // Change password action
                }
                
                ActionButton(title: "Export Data", icon: "square.and.arrow.up", color: themeManager.secondaryColor) {
                    // Export data action
                }
                
                ActionButton(title: "Sign Out", icon: "rectangle.portrait.and.arrow.right", color: .red) {
                    viewModel.signOut()
                }
            }
        }
    }
    
    // MARK: - App Info Section
    var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "App Information", icon: "info.circle")
            
            VStack(spacing: 12) {
                InfoRow(title: "Version", value: "1.0.0 (Build 42)")
                InfoRow(title: "Release Date", value: "June 15, 2023")
                InfoRow(title: "Support", value: "support@restaurantapp.com")
                InfoRow(title: "Terms of Service", value: "View", isLink: true)
                InfoRow(title: "Privacy Policy", value: "View", isLink: true)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .padding(.bottom, 60) // Extra padding at bottom
    }
    
    // MARK: - Supporting Components
    
    struct SectionHeader: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let icon: String
        
        var body: some View {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(themeManager.primaryColor)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
            }
            .padding(.leading, 8)
        }
    }
    
    struct InfoField: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let label: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
                
                Text(value)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    struct StaffMemberRow: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let staff: StaffMember
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(themeManager.primaryColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(staff.name)
                        .font(.body)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(staff.role)
                        .font(.caption)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
                
                Spacer()
                
                Circle()
                    .fill(staff.isActive ? .green : .gray)
                    .frame(width: 10, height: 10)
            }
            .padding(.vertical, 12)
        }
    }
    
    struct ToggleSetting: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let description: String
        @Binding var isOn: Bool
        
        var body: some View {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeManager.primaryColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isOn ? themeManager.primaryColor : themeManager.textColor.opacity(0.5))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: themeManager.primaryColor))
            }
            .padding(.vertical, 12)
        }
    }
    
    struct InfoRow: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let value: String
        var isLink: Bool = false
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(isLink ? themeManager.primaryColor : themeManager.textColor.opacity(0.7))
            }
        }
    }
    
    struct GlassButton: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.subheadline)
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(themeManager.textColor)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(themeManager.textColor.opacity(0.2), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    struct ActionButton: View {
        let title: String
        let icon: String
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(color)
                        .clipShape(Circle())
                    
                    Text(title)
                        .font(.body)
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(color.opacity(0.5))
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [color.opacity(0.3), .clear, color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    struct ThemeOption: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let theme: ThemeManager.AppTheme
        let isSelected: Bool
        
        // Theme color mapping function
        private func themeColor(for theme: ThemeManager.AppTheme) -> Color {
            switch theme {
            case .blue: return Color(hex: "1a73e8")
            case .dark: return Color(hex: "424242")
            case .light: return Color(hex: "BDBDBD")
            case .red: return Color(hex: "E53935")
            case .brown: return Color(hex: "8D6E63")
            case .green: return Color(hex: "43A047")
            }
        }
        
        var body: some View {
            VStack(spacing: 8) {
                Circle()
                    .fill(themeColor(for: theme))
                    .frame(width: 50, height: 50)
                    .overlay(
                        ZStack {
                            if isSelected {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 2)
                                    .padding(2)
                                
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                    )
                    .shadow(color: themeColor(for: theme).opacity(0.5), radius: isSelected ? 8 : 2, x: 0, y: 2)
                
                Text(theme.rawValue)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor)
            }
            .padding(.vertical, 4)
            .frame(height: 90)
        }
    }
}

// MARK: - View Model

class OwnerSettingsViewModel: ObservableObject {
    @Published var pushNotificationsEnabled = true
    @Published var emailNotificationsEnabled = true
    @Published var soundAlertsEnabled = true
    @Published var autoUpdatesEnabled = false
    
    // Sample staff data
    let staffMembers = [
        StaffMember(id: 1, name: "John Smith", role: "Head Chef", isActive: true),
        StaffMember(id: 2, name: "Sarah Johnson", role: "Server", isActive: true),
        StaffMember(id: 3, name: "Mike Wilson", role: "Bartender", isActive: false),
        StaffMember(id: 4, name: "Emily Chen", role: "Host", isActive: true)
    ]
    
    func signOut() {
        MainViewViewModel.shared.signOut()
    }
}

// MARK: - Supporting Types

struct StaffMember: Identifiable {
    let id: Int
    let name: String
    let role: String
    let isActive: Bool
}

// MARK: - Preview Provider

struct OwnerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerSettingsView()
            .environmentObject(RestaurantConfiguration.shared)
            .environmentObject(ThemeManager.shared)
            .background(ThemeManager.shared.backgroundGradient)
    }
}
