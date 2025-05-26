//
//  OwnerMenuView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import Foundation
import SwiftUI

struct OwnerMenuView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient from ThemeManager
                themeManager.backgroundGradient
                    .ignoresSafeArea()
                
                // Decorative elements
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 30)
                    .offset(x: -150, y: -100)
                
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 250, height: 250)
                    .blur(radius: 20)
                    .offset(x: 180, y: 400)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Menu Categories Section
                        menuCategoriesSection
                        
                        // Featured Items Section
                        featuredItemsSection
                        
                        // Special Dietary Options Section
                        dietaryOptionsSection
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    var menuCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Menu Categories")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            menuCategoriesList
        }
    }
    
    var menuCategoriesList: some View {
        VStack(spacing: 12) {
            ForEach(0..<4) { index in
                // Each menu category button
                Button {
                    // Action for selecting a menu category
                } label: {
                    HStack {
                        Image(systemName: ["fork.knife", "wineglass", "takeoutbag.and.cup.and.straw", "birthday.cake"][index % 4])
                            .font(.title3)
                            .foregroundColor(themeManager.primaryColor)
                            .frame(width: 40, height: 40)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(["Appetizers", "Main Courses", "Beverages", "Desserts"][index % 4])
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            Text("\(Int.random(in: 5...12)) items")
                                .font(.caption)
                                .foregroundColor(themeManager.textColor.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(themeManager.textColor.opacity(0.5))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
            
            // Add New Category button
            Button {
                // Action to add a new category
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(themeManager.primaryColor)
                    
                    Text("Add New Category")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
        }
    }
    
    var featuredItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Items")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            VStack(spacing: 12) {
                ForEach(0..<2) { index in
                    // Each featured item
                    HStack(alignment: .top, spacing: 12) {
                        // Image placeholder
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.primaryColor.opacity(0.2))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Image(systemName: ["fork.knife", "wineglass"][index % 2])
                                    .font(.title)
                                    .foregroundColor(themeManager.textColor)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(["Chef's Special", "Weekend Special"][index % 2])
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            Text(["Signature dish with a seasonal twist", "Limited time promotion"][index % 2])
                                .font(.caption)
                                .foregroundColor(themeManager.textColor.opacity(0.7))
                                .lineLimit(2)
                            
                            Text(["$24.99", "$19.99"][index % 2])
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(themeManager.primaryColor.opacity(0.9))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                        }
                        
                        Spacer()
                        
                        // Toggle featured status
                        Toggle("", isOn: .constant(true))
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: themeManager.primaryColor))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                
                // Add Featured Item button
                Button {
                    // Action to add a featured item
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.textColor)
                        
                        Text("Add Featured Item")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
        }
    }
    
    var dietaryOptionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Special Dietary Options")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            VStack(spacing: 12) {
                // Dietary options grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(["Vegetarian", "Vegan", "Gluten Free", "Dairy Free"], id: \.self) { option in
                        // Each dietary option
                        HStack(spacing: 8) {
                            Image(systemName: ["leaf", "leaf.fill", "wheat", "cup.and.saucer"][["Vegetarian", "Vegan", "Gluten Free", "Dairy Free"].firstIndex(of: option)! % 4])
                                .foregroundColor(themeManager.textColor)
                            
                            Text(option)
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                            
                            // Toggle dietary option
                            Toggle("", isOn: .constant(true))
                                .labelsHidden()
                                .toggleStyle(SwitchToggleStyle(tint: themeManager.primaryColor))
                                .scaleEffect(0.8)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(
                                        colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.15
                                )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                
                // Add Dietary Option button
                Button {
                    // Action to add a dietary option
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.primaryColor)
                        
                        Text("Add Dietary Option")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
        }
    }
}
