//
//  Models.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI
import CoreLocation

// MARK: - Menu Models
struct MenuItem: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String
}

struct MenuCategory: Identifiable {
    let id: UUID
    let name: String
    let items: [MenuItem]
}

// MARK: - Order Models
struct OrderItem: Identifiable {
    let id: UUID
    let menuItem: MenuItem
    var quantity: Int
    var customizations: [Customization]
    var specialInstructions: String
}

struct Customization: Identifiable {
    let id: UUID
    let name: String
    let options: [CustomizationOption]
    var selectedOption: CustomizationOption?
}

struct CustomizationOption: Identifiable {
    let id: UUID
    let name: String
    let price: Double
}

enum OrderType {
    case pickup
    case delivery
}

// MARK: - Featured Item Model
struct FeaturedItem: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String
}

struct Event: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let imageName: String
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Review Model
struct Review: Identifiable {
    let id: UUID
    let userName: String
    let rating: Int
    let comment: String
    let date: Date
    
    init(id: UUID = UUID(), userName: String, rating: Int, comment: String, date: Date = Date()) {
        self.id = id
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.date = date
    }
}



// MARK: - Models

struct RevenueData: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

struct PopularItem: Identifiable {
    let id: Int
    let name: String
    let orderCount: Int
}

struct Order: Identifiable {
    let id: Int
    let number: String
    let total: Double
    let status: OrderStatus
    
    enum OrderStatus: String {
        case pending = "Pending"
        case inProgress = "In Progress"
        case completed = "Completed"
        
        var color: Color {
            switch self {
            case .pending: return .orange
            case .inProgress: return .blue
            case .completed: return .green
            }
        }
    }
}

struct Staff: Identifiable {
    let id: Int
    let name: String
    let role: String
    let isActive: Bool
}
