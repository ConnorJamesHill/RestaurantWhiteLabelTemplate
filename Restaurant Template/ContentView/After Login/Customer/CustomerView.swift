//
//  ContentView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/2/25.
//

import SwiftUI

struct CustomerView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            MenuView()
                .tabItem {
                    Label("Menu", systemImage: "menucard")
                }
            
            ReservationView()
                .tabItem {
                    Label("Reserve", systemImage: "calendar")
                }
            
            OrderView()
                .tabItem {
                    Label("Order", systemImage: "bag")
                }
            
            InfoView()
                .tabItem {
                    Label("Info", systemImage: "info.circle")
                }
        }
        .navigationTitle(restaurant.name)
    }
}
