import Foundation
import SwiftUI

struct OwnerOrdersView: View {
    @State private var selectedOrderType = 0
    private let orderTypes = ["Active", "Completed", "All"]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search Bar
                searchBarSection
                
                // Order Type Picker
                orderTypeSection
                
                // Orders List
                ordersListSection
            }
            .padding(.horizontal)
            .navigationTitle("Orders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Refresh orders
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var searchBarSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search orders...", text: $searchText)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.top)
    }
    
    private var orderTypeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter Orders")
                .font(.headline)
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var ordersListSection: some View {
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
        HStack(spacing: 20) {
            orderStatView(count: "8", title: "Active", iconName: "clock.fill", color: .blue)
            orderStatView(count: "12", title: "Today", iconName: "calendar", color: .green)
            orderStatView(count: "3", title: "Issues", iconName: "exclamationmark.triangle.fill", color: .orange)
        }
        .padding(.vertical, 8)
    }
    
    private func orderStatView(count: String, title: String, iconName: String, color: Color) -> some View {
        VStack {
            Image(systemName: iconName)
                .foregroundColor(color)
                .font(.system(size: 20))
            
            Text(count)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                
                Spacer()
                
                Text("$\(Double.random(in: 25...150), specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                    .font(.caption)
                Text("Customer: John Doe")
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "clock.fill")
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(Date(), style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Text(status)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
                
                Spacer()
                
                Text("\(Int.random(in: 1...6)) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 4)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
