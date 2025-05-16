import Foundation
import SwiftUI

struct OwnerOrdersView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var searchText = ""
    @State private var orderTypeSelection = 0 // 0 = All, 1 = Delivery, 2 = Pickup
    
    // Sample order data
    let orders = [
        OrderData(
            id: "1234",
            type: .delivery,
            customerName: "John Smith",
            items: 3,
            total: 42.95,
            status: .pending,
            time: "12:15 PM"
        ),
        OrderData(
            id: "1235",
            type: .pickup,
            customerName: "Sarah Johnson",
            items: 2,
            total: 28.50,
            status: .inProgress,
            time: "12:30 PM"
        ),
        OrderData(
            id: "1236",
            type: .delivery,
            customerName: "David Lee",
            items: 4,
            total: 53.80,
            status: .completed,
            time: "11:45 AM"
        ),
        OrderData(
            id: "1237",
            type: .pickup,
            customerName: "Emily Chen",
            items: 1,
            total: 15.99,
            status: .pending,
            time: "1:00 PM"
        ),
        OrderData(
            id: "1238",
            type: .delivery,
            customerName: "Michael Brown",
            items: 5,
            total: 67.25,
            status: .inProgress,
            time: "1:15 PM"
        )
    ]
    
    var filteredOrders: [OrderData] {
        var filtered = orders
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { order in
                order.id.lowercased().contains(searchText.lowercased()) ||
                order.customerName.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Filter by order type
        if orderTypeSelection != 0 {
            filtered = filtered.filter { order in
                if orderTypeSelection == 1 {
                    return order.type == .delivery
                } else {
                    return order.type == .pickup
                }
            }
        }
        
        return filtered
    }
    
    var body: some View {
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
    
    // MARK: - Search Bar Section
    var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.textColor.opacity(0.7))
            
            TextField("Search by order # or customer", text: $searchText)
                .foregroundColor(themeManager.textColor)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Order Type Selection
    var orderTypeSection: some View {
        HStack(spacing: 0) {
            ForEach(["All Orders", "Delivery", "Pickup"], id: \.self) { option in
                Button {
                    withAnimation {
                        orderTypeSelection = ["All Orders", "Delivery", "Pickup"].firstIndex(of: option) ?? 0
                    }
                } label: {
                    Text(option)
                        .font(.subheadline)
                        .fontWeight(orderTypeSelection == ["All Orders", "Delivery", "Pickup"].firstIndex(of: option) ? .semibold : .regular)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .background(
                            orderTypeSelection == ["All Orders", "Delivery", "Pickup"].firstIndex(of: option) ?
                            themeManager.primaryColor.opacity(0.2) : Color.clear
                        )
                        .foregroundColor(
                            orderTypeSelection == ["All Orders", "Delivery", "Pickup"].firstIndex(of: option) ?
                            themeManager.primaryColor : themeManager.textColor.opacity(0.7)
                        )
                }
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Orders List
    var ordersListSection: some View {
        ScrollView {
            VStack(spacing: 12) {
                if filteredOrders.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(themeManager.textColor.opacity(0.5))
                            .padding(.bottom, 4)
                        
                        Text("No orders found")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                        
                        Text("Try adjusting your search or filters")
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .padding(.top, 20)
                } else {
                    ForEach(filteredOrders) { order in
                        OrderRow(order: order)
                    }
                }
            }
        }
    }
    
    // MARK: - Order Row
    struct OrderRow: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let order: OrderData
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header row with order ID and status
                HStack {
                    Text("Order #\(order.id)")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                    
                    StatusChip(status: order.status)
                }
                
                Divider()
                    .background(themeManager.textColor.opacity(0.2))
                
                // Customer and order details
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.customerName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(themeManager.textColor)
                        
                        HStack(spacing: 4) {
                            Image(systemName: order.type == .delivery ? "shippingbox.fill" : "bag.fill")
                                .font(.caption2)
                                .foregroundColor(themeManager.primaryColor)
                            
                            Text(order.type == .delivery ? "Delivery" : "Pickup")
                                .font(.caption)
                                .foregroundColor(themeManager.textColor.opacity(0.7))
                            
                            Text("•")
                                .font(.caption)
                                .foregroundColor(themeManager.textColor.opacity(0.5))
                            
                            Text("\(order.items) items")
                                .font(.caption)
                                .foregroundColor(themeManager.textColor.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("$\(String(format: "%.2f", order.total))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                        
                        Text(order.time)
                            .font(.caption)
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                    }
                }
                
                Divider()
                    .background(themeManager.textColor.opacity(0.2))
                
                // Action buttons
                HStack(spacing: 12) {
                    Button {
                        // View order details
                    } label: {
                        Text("View Details")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(themeManager.textColor)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeManager.textColor.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                    
                    Spacer()
                    
                    if order.status == .pending {
                        Button {
                            // Accept order action
                        } label: {
                            Text("Accept")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(themeManager.primaryColor)
                                .cornerRadius(8)
                                .shadow(color: themeManager.primaryColor.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    } else if order.status == .inProgress {
                        Button {
                            // Complete order action
                        } label: {
                            Text("Complete")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.green)
                                .cornerRadius(8)
                                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    struct StatusChip: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let status: OrderStatus
        
        var body: some View {
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(status.textColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(status.backgroundColor)
                .cornerRadius(12)
        }
    }
}

// MARK: - Supporting Types

struct OrderData: Identifiable {
    let id: String
    let type: OrderType
    let customerName: String
    let items: Int
    let total: Double
    let status: OrderStatus
    let time: String
}

enum OrderStatus: String {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    
    var backgroundColor: Color {
        switch self {
        case .pending: return Color.orange.opacity(0.2)
        case .inProgress: return Color.blue.opacity(0.2)
        case .completed: return Color.green.opacity(0.2)
        }
    }
    
    var textColor: Color {
        switch self {
        case .pending: return .orange
        case .inProgress: return .blue
        case .completed: return .green
        }
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
