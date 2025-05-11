import SwiftUI
import Charts // Add this import for chart components

struct OwnerDashboardView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    
    var body: some View {
        TabView {
            // Dashboard Tab - Analytics
            OwnerAnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
            
            // Menu Management Tab
            OwnerMenuView()
                .tabItem {
                    Label("Menu", systemImage: "doc.text.fill")
                }
            
            // Orders Management Tab
            OwnerOrdersView()
                .tabItem {
                    Label("Orders", systemImage: "bag.fill")
                }
            
            // Reservations Management Tab
            OwnerReservationsView()
                .tabItem {
                    Label("Tables", systemImage: "calendar")
                }
            
            // Marketing & Promotions Tab
            OwnerMarketingView()
                .tabItem {
                    Label("Marketing", systemImage: "megaphone.fill")
                }
            
            // Settings & Account Tab
            OwnerSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .navigationTitle("Restaurant Manager")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.signOut()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }
}

// MARK: - Supporting Views

// StatCard view definition
struct StatCard: View {
    let title: String
    let value: String
    let trend: Double?
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let trend = trend {
                    HStack(spacing: 4) {
                        Image(systemName: trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(abs(trend), specifier: "%.1f")%")
                    }
                    .font(.caption2)
                    .foregroundColor(trend >= 0 ? .green : .red)
                }
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Tab Views

// Analytics View - Keeps most of the content from original dashboard
struct OwnerAnalyticsView: View {
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Quick Stats Cards
                    quickStatsSection
                    
                    // Revenue Chart
                    revenueChartSection
                    
                    // Popular Items
                    popularItemsSection
                    
                    // Recent Orders
                    recentOrdersSection
                }
                .padding()
            }
            .navigationTitle("Analytics Dashboard")
        }
    }
    
    // Include all the original sections from the OwnerDashboardView
    private var quickStatsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Today's Revenue",
                value: String(format: "$%.2f", viewModel.todayRevenue),
                trend: viewModel.revenueTrend,
                icon: "dollarsign.circle.fill"
            )
            
            StatCard(
                title: "Orders Today",
                value: String(viewModel.todayOrders),
                trend: viewModel.ordersTrend,
                icon: "bag.fill"
            )
            
            StatCard(
                title: "Avg Order Value",
                value: String(format: "$%.2f", viewModel.averageOrderValue),
                trend: viewModel.avgOrderTrend,
                icon: "chart.bar.fill"
            )
            
            StatCard(
                title: "Active Tables",
                value: "\(viewModel.activeTables)/\(viewModel.totalTables)",
                trend: nil,
                icon: "tablecells.fill"
            )
        }
    }
    
    private var revenueChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Overview")
                .font(.headline)
            
            // Simple alternative without Charts if needed
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(viewModel.revenueData.prefix(7).enumerated()), id: \.element.id) { index, data in
                    HStack {
                        Text(data.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("$\(data.amount, specifier: "%.2f")")
                            .font(.subheadline)
                    }
                    
                    if index < viewModel.revenueData.prefix(7).count - 1 {
                        Divider()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var popularItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Items")
                .font(.headline)
            
            ForEach(Array(viewModel.popularItems.enumerated()), id: \.element.id) { index, item in
                HStack {
                    Text(item.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(item.orderCount) orders")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                if index < viewModel.popularItems.count - 1 {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var recentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Orders")
                .font(.headline)
            
            ForEach(viewModel.recentOrders) { order in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Order #\(order.number)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", order.total))
                            .font(.subheadline)
                    }
                    
                    Text(order.status.rawValue)
                        .font(.caption)
                        .foregroundColor(order.status.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.1))
                        .cornerRadius(4)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// Menu Management View
struct OwnerMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Menu Categories")) {
                    ForEach(1...5, id: \.self) { _ in
                        NavigationLink(destination: Text("Category Items")) {
                            HStack {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.primary)
                                Text("Category Name")
                            }
                        }
                    }
                    .onDelete { _ in }
                    
                    Button {
                        // Add new category
                    } label: {
                        Label("Add Category", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Featured Items")) {
                    ForEach(1...3, id: \.self) { _ in
                        NavigationLink(destination: Text("Edit Featured Item")) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("Featured Item Name")
                            }
                        }
                    }
                    .onDelete { _ in }
                    
                    Button {
                        // Add new featured item
                    } label: {
                        Label("Add Featured Item", systemImage: "plus.circle")
                    }
                }
                
                Section(header: Text("Special Dietary Options")) {
                    Button {
                        // Manage dietary options
                    } label: {
                        Label("Manage Dietary Labels", systemImage: "tag")
                    }
                }
            }
            .navigationTitle("Menu Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Publish menu changes
                    } label: {
                        Text("Publish")
                            .bold()
                    }
                }
            }
        }
    }
}

// Orders Management View
struct OwnerOrdersView: View {
    @State private var selectedOrderType = 0
    private let orderTypes = ["Active", "Completed", "All"]

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Order Type", selection: $selectedOrderType) {
                    ForEach(0..<orderTypes.count, id: \.self) { index in
                        Text(orderTypes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(1...10, id: \.self) { index in
                        NavigationLink(destination: Text("Order Details")) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Order #\(1000 + index)")
                                        .font(.headline)
                                    Spacer()
                                    Text("$\(Double.random(in: 25...150), specifier: "%.2f")")
                                        .fontWeight(.semibold)
                                }
                                
                                HStack {
                                    Text("Customer: John Doe")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(Date(), style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text(["Pending", "Preparing", "Ready", "Delivered"].randomElement()!)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.blue.opacity(0.2))
                                        .foregroundColor(.blue)
                                        .cornerRadius(4)
                                    
                                    Spacer()
                                    
                                    Text("\(Int.random(in: 1...6)) items")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
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
}

// Reservations Management View
struct OwnerReservationsView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                List {
                    Section(header: Text("Today's Reservations")) {
                        ForEach(1...8, id: \.self) { _ in
                            NavigationLink(destination: Text("Reservation Details")) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Smith Party")
                                            .font(.headline)
                                        Text("\(Int.random(in: 2...8)) people")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(Calendar.current.date(bySettingHour: Int.random(in: 17...21), minute: [00, 15, 30, 45].randomElement()!, second: 0, of: Date())!, style: .time)")
                                        .font(.system(.subheadline, design: .monospaced))
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Table Status")) {
                        ForEach(1...12, id: \.self) { tableNumber in
                            HStack {
                                Text("Table \(tableNumber)")
                                Spacer()
                                Text(["Available", "Reserved", "Occupied", "Maintenance"].randomElement()!)
                                    .foregroundColor([.green, .orange, .red, .gray].randomElement()!)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Table Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add new reservation
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// Marketing View
struct OwnerMarketingView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Active Promotions")) {
                    ForEach(1...3, id: \.self) { _ in
                        NavigationLink(destination: Text("Edit Promotion")) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Happy Hour Special")
                                    .font(.headline)
                                Text("50% off appetizers")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Active until Jun 30")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Section(header: Text("Customer Engagement")) {
                    NavigationLink(destination: Text("Loyalty Program")) {
                        Label("Loyalty Program", systemImage: "star.circle")
                    }
                    
                    NavigationLink(destination: Text("Push Notifications")) {
                        Label("Send Notification", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: Text("Email Campaign")) {
                        Label("Email Campaign", systemImage: "envelope")
                    }
                }
                
                Section(header: Text("Analytics")) {
                    NavigationLink(destination: Text("Promotion Impact")) {
                        Label("Promotion Impact", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    
                    NavigationLink(destination: Text("Customer Retention")) {
                        Label("Customer Retention", systemImage: "person.2")
                    }
                }
            }
            .navigationTitle("Marketing")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Create new promotion
                    } label: {
                        Text("New")
                    }
                }
            }
        }
    }
}

// Settings View
struct OwnerSettingsView: View {
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Restaurant Profile")) {
                    NavigationLink(destination: Text("Edit Restaurant Info")) {
                        Label("Restaurant Information", systemImage: "building.2")
                    }
                    
                    NavigationLink(destination: Text("Hours & Availability")) {
                        Label("Business Hours", systemImage: "clock")
                    }
                    
                    NavigationLink(destination: Text("Location Settings")) {
                        Label("Location", systemImage: "mappin.and.ellipse")
                    }
                }
                
                Section(header: Text("Staff Management")) {
                    NavigationLink(destination: Text("Staff Accounts")) {
                        Label("Staff Accounts", systemImage: "person.3")
                    }
                    
                    NavigationLink(destination: Text("Permissions")) {
                        Label("Permissions", systemImage: "lock.shield")
                    }
                }
                
                Section(header: Text("System")) {
                    NavigationLink(destination: Text("Payment Methods")) {
                        Label("Payment Settings", systemImage: "creditcard")
                    }
                    
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notification Settings", systemImage: "bell.badge")
                    }
                    
                    NavigationLink(destination: Text("App Settings")) {
                        Label("App Settings", systemImage: "gear")
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.signOut()
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
