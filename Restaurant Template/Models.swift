//
//  Models.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import Foundation

struct MenuCategory: Identifiable {
    let id: UUID
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String
}

struct Reservation: Identifiable {
    let id: UUID
    let name: String
    let date: Date
    let partySize: Int
    let contactInfo: String
}

struct Review: Identifiable {
    let id: UUID
    let author: String
    let rating: Int
    let comment: String
    let date: Date
}
