import SwiftUI
import Charts

struct OwnerDashboardView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    @State private var showMenu: Bool = false
    @State private var selectedTab = Tab.analytics
    
    enum Tab: String, CaseIterable {
        case analytics = "Analytics"
        case menu = "Menu"
        case orders = "Orders"
        case tables = "Tables"
        case marketing = "Marketing"
        case settings = "Settings" // Keep settings in enum but don't show in tab bar
        
        var icon: String {
            switch self {
            case .analytics: return "chart.bar.fill"
            case .menu: return "doc.text.fill"
            case .orders: return "bag.fill"
            case .tables: return "calendar"
            case .marketing: return "megaphone.fill"
            case .settings: return "gear"
            }
        }
        
        // New computed property to get tabs for the bottom bar
        static var tabBarCases: [Tab] {
            return [.analytics, .menu, .orders, .tables, .marketing]
        }
    }
    
    // Blue gradient background for sidebar
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"),
                Color(hex: "0d47a1"),
                Color(hex: "002171"),
                Color(hex: "002984")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    init() {
        // Create a blue gradient for the tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Use a visual effect with blue tint
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        appearance.backgroundEffect = blurEffect
        
        // Add a blue overlay color
        appearance.backgroundColor = UIColor(Color(hex: "0d47a1").opacity(0.7))
        
        // Use this appearance for the tab bar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Set the unselected icons to white with reduced opacity
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        
        // Set the selected icons to full white
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Configure the navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
        navBarAppearance.backgroundColor = UIColor(Color(hex: "0d47a1").opacity(0.7))
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Remove the shadow (line underneath the navigation bar)
        navBarAppearance.shadowColor = .clear
        
        // Apply the appearance to all navigation bars
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var body: some View {
        AnimatedSideBar(
            rotatesWhenExpands: true,
            disablesInteraction: true,
            sideMenuWidth: 250,
            cornerRadius: 25,
            showMenu: $showMenu
        ) { safeArea in
            // Main Content - TabView
            NavigationStack {
                // We create separate content for each tab to ensure toolbar refreshes
                Group {
                    if selectedTab == .analytics {
                        AnalyticsWrapper()
                            .transition(.opacity)
                    } else if selectedTab == .menu {
                        MenuWrapper()
                            .transition(.opacity)
                    } else if selectedTab == .orders {
                        OrdersWrapper()
                            .transition(.opacity)
                    } else if selectedTab == .tables {
                        ReservationsWrapper()
                            .transition(.opacity)
                    } else if selectedTab == .marketing {
                        MarketingWrapper()
                            .transition(.opacity)
                    } else if selectedTab == .settings {
                        SettingsWrapper()
                            .transition(.opacity)
                    }
                }
                // Custom tab bar at the bottom
                .safeAreaInset(edge: .bottom) {
                    CustomTabBar(selectedTab: $selectedTab)
                        .background(.ultraThinMaterial)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                showMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.white)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text(getTitleForTab(selectedTab))
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    // Now we use different toolbar items based on the selected tab
                    if selectedTab == .menu {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                // Publish menu changes
                            } label: {
                                Text("Publish")
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
                                    )
                            }
                        }
                    } else if selectedTab == .marketing {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                // Create new promotion
                            } label: {
                                Text("New")
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
                                    )
                            }
                        }
                    } else {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                viewModel.signOut()
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        } menuView: { safeArea in
            // Sidebar Menu View
            SideBarMenuView(safeArea)
        } background: {
            backgroundGradient
                .ignoresSafeArea()
        }
    }
    
    // Get the appropriate title for the selected tab
    private func getTitleForTab(_ tab: Tab) -> String {
        switch tab {
        case .analytics:
            return "Analytics"
        case .menu:
            return "Menu Management"
        case .orders:
            return "Orders"
        case .tables:
            return "Tables & Reservations"
        case .marketing:
            return "Marketing"
        case .settings:
            return "Settings"
        }
    }
    
    // Custom tab bar
    struct CustomTabBar: View {
        @Binding var selectedTab: Tab
        
        var body: some View {
            HStack(spacing: 0) {
                // Only show tabs that should appear in the tab bar (not settings)
                ForEach(Tab.tabBarCases, id: \.self) { tab in
                    Button {
                        withAnimation {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20))
                            
                            Text(tab.rawValue)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.5))
                    }
                }
            }
            .background(Color(hex: "0d47a1").opacity(0.7))
        }
    }
    
    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image("restaurant_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                
                Text(restaurant.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.top, safeArea.top + 15)
            .padding(.bottom, 30)
            .padding(.horizontal, 25)
            
            // Menu Items - show ALL tabs in the sidebar including Settings
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                        withAnimation {
                            showMenu = false
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: tab.icon)
                                .font(.title3)
                                .frame(width: 30)
                            
                            Text(tab.rawValue)
                                .font(.headline)
                        }
                        .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.7))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(
                            selectedTab == tab ?
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.ultraThinMaterial)
                            : nil
                        )
                    }
                }
            }
            .padding(.horizontal, 15)
            
            Spacer()
            
            // Sign Out Button
            Button {
                viewModel.signOut()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title3)
                        .frame(width: 30)
                    
                    Text("Sign Out")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
            }
            .padding(.horizontal, 15)
            .padding(.bottom, safeArea.bottom + 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    // Wrapper views
    struct AnalyticsWrapper: View {
        var body: some View {
            let view = OwnerAnalyticsView()
            return ZStack {
                view.backgroundGradient.ignoresSafeArea()
                
                // Decorative elements
                Circle()
                    .fill(Color.black.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 30)
                    .offset(x: -150, y: -100)
                
                Circle()
                    .fill(Color.black.opacity(0.08))
                    .frame(width: 250, height: 250)
                    .blur(radius: 20)
                    .offset(x: 180, y: 400)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title with glass effect
                        Text("Analytics Dashboard")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 6)
                            .padding(.top, 10)
                        
                        // Quick Stats Cards
                        view.quickStatsSection
                        
                        // Revenue Chart
                        view.revenueChartSection
                        
                        // Popular Items
                        view.popularItemsSection
                        
                        // Recent Orders
                        view.recentOrdersSection
                    }
                    .padding()
                }
            }
        }
    }
    
    struct MenuWrapper: View {
        var body: some View {
            let view = OwnerMenuView()
            return ZStack {
                view.backgroundGradient.ignoresSafeArea()
                
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
                        view.menuCategoriesSection
                        
                        // Featured Items Section
                        view.featuredItemsSection
                        
                        // Special Dietary Options Section
                        view.dietaryOptionsSection
                    }
                    .padding()
                }
            }
        }
    }
    
    struct OrdersWrapper: View {
        var body: some View {
            let view = OwnerOrdersView()
            return ZStack {
                view.backgroundGradient.ignoresSafeArea()
                
                // Content without NavigationStack or toolbar
                VStack(spacing: 16) {
                    // Search Bar
                    view.searchBarSection
                    
                    // Order Type Picker
                    view.orderTypeSection
                    
                    // Orders List
                    view.ordersListSection
                }
                .padding(.horizontal)
            }
        }
    }
    
    struct ReservationsWrapper: View {
        var body: some View {
            OwnerReservationsView()
        }
    }
    
    struct MarketingWrapper: View {
        var body: some View {
            let view = OwnerMarketingView()
            return ZStack {
                view.backgroundGradient.ignoresSafeArea()
                
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
                        // Marketing Overview
                        view.marketingOverviewSection
                        
                        // Active Promotions
                        view.activePromotionsSection
                        
                        // Customer Engagement
                        view.customerEngagementSection
                        
                        // Analytics
                        view.analyticsSection
                    }
                    .padding()
                }
            }
        }
    }
    
    struct SettingsWrapper: View {
        var body: some View {
            let view = OwnerSettingsView()
            return ZStack {
                view.backgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        view.profileHeader
                        
                        // Restaurant Profile
                        view.restaurantProfileSection
                        
                        // Staff Management
                        view.staffManagementSection
                        
                        // System Settings
                        view.systemSection
                        
                        // Account Actions
                        view.accountActionsSection
                        
                        // App Info
                        view.appInfoSection
                    }
                    .padding()
                }
            }
        }
    }
}

// Extension to support hex color codes
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
