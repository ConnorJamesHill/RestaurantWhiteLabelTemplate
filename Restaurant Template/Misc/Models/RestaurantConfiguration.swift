//
//  RestaurantConfiguration.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/6/25.
//

import MapKit
import SwiftUI

// Central configuration class for restaurant information
class RestaurantConfiguration: ObservableObject {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    
    // Restaurant Identity
    @Published var name: String = "Table Tap"
    @Published var tagline: String = "Fine Dining & Culinary Excellence"
    @Published var welcomeMessage = "Welcome to Table Tap, where culinary artistry meets exceptional service. Experience our chef-driven menu featuring locally-sourced ingredients and seasonal specialties."
    @Published var description: String = "Established in 2010, Table Tap offers a modern take on classic cuisine. Our chef-driven menu features locally sourced ingredients and changes seasonally to showcase the freshest flavors."
    @Published var logoImageName: String = "restaurant_logo"
    @Published var heroImageName: String = "restaurant_hero"
    
    // Contact Information
    @Published var phoneNumber: String = "(555) 123-4567"
    @Published var emailAddress: String = "info@tabletap.com"
    @Published var websiteURL: String = "www.tabletap.com"
    @Published var address: String = "123 Main Street, Anytown, CA 94000"
    @Published var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    // In RestaurantConfiguration class
    let socialMedia: [(String, String)] = [
        ("Instagram", "@tabletap"),
        ("Facebook", "TableTap"),
        ("Twitter", "@tabletap"),
        ("TikTok", "@tabletap"),
        ("YouTube", "TableTap")
    ]
    
    // Hours
    @Published var businessHours: [(day: String, hours: String)] = [
        ("Monday", "11:00 AM - 9:00 PM"),
        ("Tuesday", "11:00 AM - 9:00 PM"),
        ("Wednesday", "11:00 AM - 9:00 PM"),
        ("Thursday", "11:00 AM - 10:00 PM"),
        ("Friday", "11:00 AM - 11:00 PM"),
        ("Saturday", "10:00 AM - 11:00 PM"),
        ("Sunday", "10:00 AM - 9:00 PM")
    ]
    
    // Menu Categories
    @Published var menuCategories: [MenuCategory] = [
        MenuCategory(id: UUID(), name: "Appetizers", items: [
            MenuItem(id: UUID(), name: "Mozzarella Sticks", description: "Crispy, golden-brown mozzarella sticks served with marinara sauce.", price: 8.99, imageName: "mozzarella_sticks"),
            MenuItem(id: UUID(), name: "Spinach Artichoke Dip", description: "Creamy spinach and artichoke dip served with tortilla chips.", price: 9.99, imageName: "spinach_dip")
        ]),
        MenuCategory(id: UUID(), name: "Main Courses", items: [
            MenuItem(id: UUID(), name: "Classic Burger", description: "Juicy beef patty with lettuce, tomato, and special sauce on a brioche bun.", price: 12.99, imageName: "burger"),
            MenuItem(id: UUID(), name: "Margherita Pizza", description: "Traditional pizza with tomato sauce, fresh mozzarella, and basil.", price: 14.99, imageName: "pizza")
        ]),
        MenuCategory(id: UUID(), name: "Desserts", items: [
            MenuItem(id: UUID(), name: "Chocolate Cake", description: "Rich, moist chocolate cake with a velvety ganache.", price: 6.99, imageName: "chocolate_cake"),
            MenuItem(id: UUID(), name: "Cheesecake", description: "Creamy New York-style cheesecake with a graham cracker crust.", price: 7.99, imageName: "cheesecake")
        ])
    ]
    
    // App Theme (Optional)
    @Published var primaryColor: Color = .blue
    @Published var secondaryColor: Color = .gray
    
    // Singleton instance for easy access
    static let shared = RestaurantConfiguration()
    
    // Returns the hours for today
    var todayHours: String {
        let weekday = Calendar.current.component(.weekday, from: Date())
        guard weekday >= 1 && weekday <= 7, businessHours.count >= 7 else {
            return "Closed"
        }
        // weekday is 1-based (1 = Sunday)
        // Convert to our array index (where Monday might be first)
        let index = (weekday + 5) % 7  // If Monday is first (index 0)
        return businessHours[index].hours
    }
}
