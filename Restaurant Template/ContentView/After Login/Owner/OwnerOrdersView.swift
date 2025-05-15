import Foundation
import SwiftUI

struct OwnerOrdersView: View {
    @State private var selectedOrderType = 0
    private let orderTypes = ["Active", "Completed", "All"]
    @State private var searchText = ""
    @Environment(\.colorScheme) private var colorScheme
    
    // Blue gradient background - matching other owner views
    var backgroundGradient: LinearGradient {
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
                
                VStack(spacing: 16) {
                    // Search Bar
                    searchBarSection
                    
                    // Order Type Picker
                    orderTypeSection
                    
                    // Orders List
                    ordersListSection
                }
                .padding(.horizontal)
            }
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Orders")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Refresh orders
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.7))
            
            TextField("Search orders...", text: $searchText)
                .font(.subheadline)
                .foregroundColor(.white)
                .accentColor(.white.opacity(0.8))
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    LinearGradient(
                        colors: [.black.opacity(0.6), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
        .padding(.top)
    }
    
    var orderTypeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter Orders")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 4)
            
            Picker("Order Type", selection: $selectedOrderType) {
                ForEach(0..<orderTypes.count, id: \.self) { index in
                    Text(orderTypes[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(8)
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    var ordersListSection: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Summary Stats
                ordersSummarySection
                
                // Order Items
                ForEach(1...10, id: \.self) { index in
                    NavigationLink(destination: Text("Order Details")) {
                        orderItemView(index: index)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    private var ordersSummarySection: some View {
        HStack(spacing: 15) {
            glassOrderStatView(count: "8", title: "Active", iconName: "clock.fill", color: .blue)
            glassOrderStatView(count: "12", title: "Today", iconName: "calendar", color: .green)
            glassOrderStatView(count: "3", title: "Issues", iconName: "exclamationmark.triangle.fill", color: .orange)
        }
        .padding(.vertical, 8)
    }
    
    private func glassOrderStatView(count: String, title: String, iconName: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding(8)
                .background(color.opacity(0.3))
                .clipShape(Circle())
            
            Text(count)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.black.opacity(0.6), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private func orderItemView(index: Int) -> some View {
        let status = ["Pending", "Preparing", "Ready", "Delivered"].randomElement()!
        let statusColor: Color = {
            switch status {
            case "Pending": return .orange
            case "Preparing": return .blue
            case "Ready": return .green
            case "Delivered": return .gray
            default: return .primary
            }
        }()
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Order #\(1000 + index)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("$\(Double.random(in: 25...150), specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
                Text("Customer: John Doe")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "clock.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.caption)
                Text(Date(), style: .time)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            HStack {
                GlassStatusPill(status: status, color: statusColor)
                
                Spacer()
                
                Text("\(Int.random(in: 1...6)) items")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.trailing, 4)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Supporting Views

struct GlassStatusPill: View {
    let status: String
    let color: Color
    
    var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.5), lineWidth: 0.15)
            )
            .clipShape(Capsule())
            .shadow(color: color.opacity(0.2), radius: 2, x: 0, y: 1)
    }
}
