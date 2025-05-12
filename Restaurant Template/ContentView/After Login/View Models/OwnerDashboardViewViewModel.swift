import SwiftUI

class OwnerDashboardViewViewModel: ObservableObject {
    @Published var todayRevenue: Double = 1234.56
    @Published var todayOrders: Int = 45
    @Published var averageOrderValue: Double = 27.43
    @Published var activeTables: Int = 8
    @Published var totalTables: Int = 12
    
    @Published var revenueTrend: Double = 5.2
    @Published var ordersTrend: Double = -2.1
    @Published var avgOrderTrend: Double = 3.4
    
    @Published var revenueData: [RevenueData] = []
    @Published var popularItems: [PopularItem] = []
    @Published var recentOrders: [Order] = []
    @Published var activeStaff: [Staff] = []
    
    init() {
        loadDashboardData()
    }
    
    func signOut() {
        // Call the MainViewModel's signOut method
        MainViewViewModel.shared.signOut()
    }
    
    private func loadDashboardData() {
        // Load sample data
        loadRevenueData()
        loadPopularItems()
        loadRecentOrders()
        loadActiveStaff()
    }
    
    private func loadRevenueData() {
        // Sample revenue data for the past week
        revenueData = (0..<7).map { day in
            RevenueData(
                date: Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date(),
                amount: Double.random(in: 800...2000)
            )
        }.reversed()
    }
    
    private func loadPopularItems() {
        popularItems = [
            PopularItem(id: 1, name: "Truffle Pasta", orderCount: 42),
            PopularItem(id: 2, name: "Wagyu Burger", orderCount: 38),
            PopularItem(id: 3, name: "Seafood Risotto", orderCount: 31),
            PopularItem(id: 4, name: "Tiramisu", orderCount: 27)
        ]
    }
    
    private func loadRecentOrders() {
        recentOrders = [
            Order(id: 1, number: "1234", total: 89.99, status: .completed),
            Order(id: 2, number: "1235", total: 145.50, status: .inProgress),
            Order(id: 3, number: "1236", total: 67.25, status: .pending)
        ]
    }
    
    private func loadActiveStaff() {
        activeStaff = [
            Staff(id: 1, name: "John Smith", role: "Head Chef", isActive: true),
            Staff(id: 2, name: "Sarah Johnson", role: "Server", isActive: true),
            Staff(id: 3, name: "Mike Wilson", role: "Bartender", isActive: false)
        ]
    }
}
