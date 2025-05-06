//
//  InfoView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI
import MapKit

struct InfoView: View {
    // Restaurant data - in a real app, you'd load this from a database/API
    let restaurantName = "Bistro Deluxe"
    let restaurantLogo = "restaurant_logo" // Add this image to your assets
    let description = "Established in 2010, Bistro Deluxe offers a modern take on classic cuisine. Our chef-driven menu features locally sourced ingredients and changes seasonally to showcase the freshest flavors."
    
    let phoneNumber = "(555) 123-4567"
    let emailAddress = "info@bistrodeluxe.com"
    let websiteURL = "www.bistrodeluxe.com"
    
    let address = "123 Main Street, Anytown, CA 94000"
    let location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // SF coordinates as example
    
    let businessHours = [
        ("Monday", "11:00 AM - 9:00 PM"),
        ("Tuesday", "11:00 AM - 9:00 PM"),
        ("Wednesday", "11:00 AM - 9:00 PM"),
        ("Thursday", "11:00 AM - 10:00 PM"),
        ("Friday", "11:00 AM - 11:00 PM"),
        ("Saturday", "10:00 AM - 11:00 PM"),
        ("Sunday", "10:00 AM - 9:00 PM")
    ]
    
    let socialMedia = [
        ("Instagram", "instagram", "@bistrodeluxe"),
        ("Facebook", "facebook", "BistroDeluxe"),
        ("Twitter", "twitter", "@BistroDeluxe")
    ]
    
    @State private var region: MKCoordinateRegion
    @State private var showingFullMap = false
    
    init() {
        // Initialize map region
        _region = State(initialValue: MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        NavigationStack {
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
                }
                .padding()
            }
            .navigationTitle("About Us")
            .sheet(isPresented: $showingFullMap) {
                fullMapView
            }
        }
    }
    
    // MARK: - UI Components
    
    private var restaurantHeader: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(restaurantLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.2), lineWidth: 2)
                )
                .shadow(radius: 5)
            
            Text(restaurantName)
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Our Story")
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var hoursSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Hours")
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(businessHours, id: \.0) { day, hours in
                    HStack(alignment: .top) {
                        Text(day)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(width: 100, alignment: .leading)
                        
                        Text(hours)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Location")
            
            Text(address)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Map view
            Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: location)]) { annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .primary)
            }
            .frame(height: 180)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .onTapGesture {
                showingFullMap = true
            }
            
            // Get directions button
            Button {
                openMapsApp()
            } label: {
                Label("Get Directions", systemImage: "location.fill")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Contact")
            
            contactButton(icon: "phone.fill", text: phoneNumber) {
                callPhoneNumber()
            }
            
            contactButton(icon: "envelope.fill", text: emailAddress) {
                sendEmail()
            }
            
            contactButton(icon: "globe", text: websiteURL) {
                openWebsite()
            }
        }
    }
    
    private var socialMediaSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Follow Us")
            
            HStack(spacing: 24) {
                ForEach(socialMedia, id: \.0) { platform, icon, handle in
                    VStack(spacing: 6) {
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(.primary)
                        Text(handle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        // Would open social media app in a real implementation
                    }
                }
                Spacer()
            }
            .padding(.top, 4)
        }
    }
    
    private var fullMapView: some View {
        NavigationStack {
            Map(coordinateRegion: $region, annotationItems: [MapAnnotation(coordinate: location)]) { annotation in
                MapMarker(coordinate: annotation.coordinate, tint: .primary)
            }
            .edgesIgnoringSafeArea(.all)
            .navigationTitle(restaurantName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingFullMap = false
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        openMapsApp()
                    } label: {
                        Label("Get Directions", systemImage: "location.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 4)
    }
    
    private func contactButton(icon: String, text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .frame(width: 24, height: 24)
                
                Text(text)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Actions
    
    private func openMapsApp() {
        let url = URL(string: "maps://?q=\(address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func callPhoneNumber() {
        let formattedNumber = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if let url = URL(string: "tel://\(formattedNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func sendEmail() {
        if let url = URL(string: "mailto:\(emailAddress)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openWebsite() {
        if let url = URL(string: "https://\(websiteURL)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Models

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Preview

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
