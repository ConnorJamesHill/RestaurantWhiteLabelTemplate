import Foundation
import SwiftUI

struct OwnerMenuView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // Using the same blue gradient from OwnerAnalyticsView
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"), // Vibrant blue
                Color(hex: "0d47a1"), // Deep blue
                Color(hex: "002171"), // Dark blue
                Color(hex: "002984")  // Navy blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
                    .ignoresSafeArea()
                
                // Decorative elements - same as AnalyticsView
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
            .navigationTitle("Menu Management")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Publish menu changes
                    } label: {
                        Text("Publish")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    private var menuCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Menu Categories")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 4)
                .foregroundColor(.white)
            
            ForEach(1...5, id: \.self) { index in
                NavigationLink(destination: Text("Category Items")) {
                    HStack {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 32, height: 32)
                            .background(Color.primary.opacity(0.2))
                            .clipShape(Circle())
                        
                        Text("Category Name \(index)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.6), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 16)
            }
            
            Button {
                // Add new category
            } label: {
                HStack {
                    Spacer()
                    Label("Add Category", systemImage: "plus.circle")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var featuredItemsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Featured Items")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 4)
                .foregroundColor(.white)
            
            ForEach(1...3, id: \.self) { index in
                NavigationLink(destination: Text("Edit Featured Item")) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.headline)
                            .frame(width: 32, height: 32)
                            .background(Color.yellow.opacity(0.15))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Featured Item \(index)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Text("$\(11 + index).99")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.6), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 16)
            }
            
            Button {
                // Add new featured item
            } label: {
                HStack {
                    Spacer()
                    Label("Add Featured Item", systemImage: "plus.circle")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var dietaryOptionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Special Dietary Options")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 4)
                .foregroundColor(.white)
            
            Button {
                // Manage dietary options
            } label: {
                HStack {
                    Image(systemName: "tag")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.15))
                        .clipShape(Circle())
                    
                    Text("Manage Dietary Labels")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("12 labels")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 16)
            
            VStack {
                HStack(spacing: 12) {
                    GlassTagView(name: "Vegetarian", color: .green)
                    GlassTagView(name: "Vegan", color: .green)
                    GlassTagView(name: "GF", color: .blue)
                }
                
                HStack(spacing: 12) {
                    GlassTagView(name: "Spicy", color: .red)
                    GlassTagView(name: "Contains Nuts", color: .orange)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Supporting Views

struct GlassTagView: View {
    let name: String
    let color: Color
    
    var body: some View {
        Text(name)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .background(color.opacity(0.1))
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}
