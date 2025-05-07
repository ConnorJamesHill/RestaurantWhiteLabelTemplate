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

// MARK: - Reservation Model
struct Reservation: Identifiable {
    let id: UUID
    var name: String
    var email: String
    var phoneNumber: String
    var date: Date
    var time: Date
    var partySize: Int
    var specialRequests: String
    var status: ReservationStatus
    
    init(
        id: UUID = UUID(),
        name: String = "",
        email: String = "",
        phoneNumber: String = "",
        date: Date = Date(),
        time: Date = Date(),
        partySize: Int = 2,
        specialRequests: String = "",
        status: ReservationStatus = .pending
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.date = date
        self.time = time
        self.partySize = partySize
        self.specialRequests = specialRequests
        self.status = status
    }
}

enum ReservationStatus: String {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case cancelled = "Cancelled"
    case completed = "Completed"
}
