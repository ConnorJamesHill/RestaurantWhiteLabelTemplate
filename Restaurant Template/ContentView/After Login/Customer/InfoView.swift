//
//  InfoView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI
import MapKit

struct InfoView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var authViewModel = MainViewViewModel.shared
    
    // Default coordinate - will be updated from restaurant config in onAppear
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var showingFullMap = false
    @State private var selectedTabIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
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
                    VStack(alignment: .leading, spacing: 24) {
                        // Restaurant header
                        restaurantHeader
                        
                        // About section
                        aboutSection
                        
                        // Hours section
                        hoursSection
                        
                        // Location section
                        locationSection
                        
                        // Contact section
                        contactSection
                        
                        // Social media
                        socialMediaSection
                        
                        // Logout section
                        logoutSection
                    }
                    .padding()
                    .padding(.horizontal)
                }
            }
            .navigationTitle("About Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("About Us")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
            .sheet(isPresented: $showingFullMap) {
                fullMapViewWithFixedTabBar
            }
            .onAppear {
                // Update region when view appears and restaurant data is available
                region = MKCoordinateRegion(
                    center: restaurant.location,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                
                // Force tab bar appearance when the view appears
                themeManager.updateAppearance()
            }
        }
    }
    
    // MARK: - UI Components
    
    private var restaurantHeader: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(restaurant.logoImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.3), lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            Text(restaurant.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
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
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Our Story")
            
            Text(restaurant.description)
                .font(.body)
                .foregroundColor(themeManager.textColor.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
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
        }
    }
    
    private var hoursSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Hours")
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(restaurant.businessHours, id: \.0) { day, hours in
                    HStack(alignment: .top) {
                        Text(day)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(themeManager.textColor)
                            .frame(width: 100, alignment: .leading)
                        
                        Text(hours)
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                    }
                    .padding(.vertical, 6)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
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
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Location")
            
            Text(restaurant.address)
                .font(.subheadline)
                .foregroundColor(themeManager.textColor.opacity(0.9))
                .padding(.bottom, 4)
            
            // Custom map wrapper to preserve tab bar appearance
            MapWithConsistentTabBar(
                region: $region,
                coordinate: restaurant.location,
                title: restaurant.name,
                themeManager: themeManager
            )
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.textColor.opacity(0.3), lineWidth: 0.15)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            .onTapGesture {
                showingFullMap = true
            }
            
            // Get directions button
            Button {
                openMapsApp()
            } label: {
                Label("Get Directions", systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
            }
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Contact")
            
            VStack(spacing: 12) {
                contactButton(icon: "phone.fill", text: restaurant.phoneNumber) {
                    callPhoneNumber()
                }
                
                contactButton(icon: "envelope.fill", text: restaurant.emailAddress) {
                    sendEmail()
                }
                
                contactButton(icon: "globe", text: restaurant.websiteURL) {
                    openWebsite()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
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
        }
    }
    
    private var socialMediaSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Follow Us")
            
            HStack(spacing: 24) {
                ForEach(restaurant.socialMedia, id: \.0) { platform, handle in
                    SocialMediaButton(
                        platform: platform,
                        handle: handle,
                        themeManager: themeManager
                    ) {
                        openSocialMedia(platform: platform, handle: handle)
                    }
                }
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
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
        }
    }
    
    private var logoutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Account")
            
            Button(action: {
                print("Sign out button tapped")
                authViewModel.signOut()
                print("Sign out completed, isAuthenticated: \(authViewModel.isAuthenticated)")
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 16))
                        .foregroundColor(themeManager.textColor)
                        .frame(width: 32, height: 32)
                        .background(Color.red.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text("Sign Out")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
            }
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    private var fullMapViewWithFixedTabBar: some View {
        NavigationStack {
            ZStack {
                // Background gradient for the map view too
                themeManager.backgroundGradient.ignoresSafeArea()
                
                // Use custom map here too to preserve tab bar appearance
                MapWithConsistentTabBar(
                    region: $region,
                    coordinate: restaurant.location,
                    title: restaurant.name,
                    themeManager: themeManager
                )
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle(restaurant.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingFullMap = false
                    }
                    .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        openMapsApp()
                    } label: {
                        Label("Get Directions", systemImage: "location.fill")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(themeManager.textColor)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 0.15
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(themeManager.textColor)
            .padding(.vertical, 4)
            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
    }
    
    private func contactButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(themeManager.textColor)
                    .frame(width: 32, height: 32)
                    .background(themeManager.primaryColor.opacity(0.2))
                    .clipShape(Circle())
                
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.textColor.opacity(0.2), lineWidth: 0.15)
            )
        }
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Actions
    
    private func openMapsApp() {
        let url = URL(string: "maps://?q=\(restaurant.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func callPhoneNumber() {
        #if targetEnvironment(simulator)
        // Show a simple print message for simulator
        print("📱 SIMULATOR: Would call \(restaurant.phoneNumber)")
        #else
        // Real device implementation
        let digits = restaurant.phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel:\(digits)") {
            UIApplication.shared.open(url)
        }
        #endif
    }
    
    private func sendEmail() {
        #if targetEnvironment(simulator)
        // Show a simple print message for simulator
        print("📧 SIMULATOR: Would email \(restaurant.emailAddress)")
        #else
        // Real device implementation
        if let url = URL(string: "mailto:\(restaurant.emailAddress)") {
            UIApplication.shared.open(url)
        }
        #endif
    }
    
    private func openWebsite() {
        if let url = URL(string: "https://\(restaurant.websiteURL)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openSocialMedia(platform: String, handle: String) {
        var urlString = ""
        
        switch platform.lowercased() {
        case "instagram":
            urlString = "https://instagram.com/\(handle.replacingOccurrences(of: "@", with: ""))"
        case "facebook":
            urlString = "https://facebook.com/\(handle)"
        case "twitter":
            urlString = "https://twitter.com/\(handle.replacingOccurrences(of: "@", with: ""))"
        case "tiktok":
            urlString = "https://tiktok.com/@\(handle.replacingOccurrences(of: "@", with: ""))"
        case "youtube":
            urlString = "https://youtube.com/\(handle)"
        default:
            return
        }
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

// Simplified custom map wrapper that preserves tab bar appearance
struct MapWithConsistentTabBar: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    let coordinate: CLLocationCoordinate2D
    let title: String
    let themeManager: ThemeManager
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
        
        // Apply the theme-based tab bar appearance
        DispatchQueue.main.async {
            themeManager.updateAppearance()
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Simple region update
        uiView.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {}
}

// Social media button view
struct SocialMediaButton: View {
    let platform: String
    let handle: String
    let themeManager: ThemeManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(platform.lowercased())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        Circle()
                            .stroke(themeManager.textColor.opacity(0.3), lineWidth: 0.15)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Text(handle)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.8))
            }
        }
    }
}
