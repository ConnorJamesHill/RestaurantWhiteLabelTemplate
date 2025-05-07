//
//  Restaurant_TemplateApp.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/2/25.
//

import SwiftUI

@main
struct Restaurant_TemplateApp: App {
    @StateObject private var restaurantConfig = RestaurantConfiguration.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(restaurantConfig)
        }
    }
}
