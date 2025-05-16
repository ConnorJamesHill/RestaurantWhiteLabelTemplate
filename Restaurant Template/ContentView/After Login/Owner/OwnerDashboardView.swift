import SwiftUI
import Charts

struct OwnerDashboardView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    @State private var showMenu: Bool = false
    @State private var selectedTab = Tab.analytics
    @State private var isChangingView = false // Track view change state
    
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
        
        // Computed property to get tabs for the bottom bar
        static var tabBarCases: [Tab] {
            return [.analytics, .menu, .orders, .tables, .marketing]
        }
    }
    
    init() {
        // No UIKit appearance configuration - ThemeManager handles this
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
                ZStack {
                    // Background gradient from ThemeManager
                    themeManager.backgroundGradient
                        .ignoresSafeArea()
                    
                    // Content views with transitions
                    Group {
                        if selectedTab == .analytics {
                            AnalyticsWrapper(dashboardViewModel: viewModel)
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
                    .opacity(isChangingView ? 0 : 1) // Fade out during transitions
                    
                    // Custom tab bar at the bottom
                    .safeAreaInset(edge: .bottom) {
                        CustomTabBar(selectedTab: $selectedTab, isChangingView: $isChangingView)
                            .background(.ultraThinMaterial)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                showMenu.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(themeManager.textColor)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text(getTitleForTab(selectedTab))
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                    }
                    
                    // Toolbar trailing items based on the selected tab
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
                                    .foregroundColor(themeManager.textColor)
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
                                    .foregroundColor(themeManager.textColor)
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
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                    }
                }
            }
        } menuView: { safeArea in
            // Sidebar Menu View
            SideBarMenuView(safeArea)
        } background: {
            themeManager.backgroundGradient
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
        @EnvironmentObject var themeManager: ThemeManager
        @Binding var selectedTab: Tab
        @Binding var isChangingView: Bool
        
        var body: some View {
            HStack(spacing: 0) {
                // Only show tabs that should appear in the tab bar (not settings)
                ForEach(Tab.tabBarCases, id: \.self) { tab in
                    Button {
                        handleTabSelection(tab)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 20))
                            
                            Text(tab.rawValue)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .foregroundColor(selectedTab == tab ? themeManager.textColor : themeManager.textColor.opacity(0.5))
                    }
                }
            }
            // Use the themeManager's tabBarColor directly for the tab bar background
            .background(themeManager.tabBarColor)
        }
        
        private func handleTabSelection(_ tab: Tab) {
            guard tab != selectedTab else { return }
            
            // Start transition
            withAnimation(.easeOut(duration: 0.15)) {
                isChangingView = true
            }
            
            // Wait briefly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                // Switch tab
                selectedTab = tab
                
                // Complete transition
                withAnimation(.easeIn(duration: 0.2)) {
                    isChangingView = false
                }
            }
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
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
            }
            .padding(.top, safeArea.top + 15)
            .padding(.bottom, 30)
            .padding(.horizontal, 25)
            
            // Menu Items - show ALL tabs in the sidebar including Settings
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Button {
                        handleSidebarTabSelection(tab)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: tab.icon)
                                .font(.title3)
                                .frame(width: 30)
                            
                            Text(tab.rawValue)
                                .font(.headline)
                        }
                        .foregroundColor(selectedTab == tab ? themeManager.textColor : themeManager.textColor.opacity(0.7))
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
            
            // Theme Selector
            ThemeSelector()
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            
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
                .foregroundColor(themeManager.textColor)
                .padding(.vertical, 12)
                .padding(.horizontal, 15)
            }
            .padding(.horizontal, 15)
            .padding(.bottom, safeArea.bottom + 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    // Coordinate sidebar navigation with proper transitions
    private func handleSidebarTabSelection(_ tab: Tab) {
        guard tab != selectedTab else {
            // Just close the menu if it's the same tab
            withAnimation {
                showMenu = false
            }
            return
        }
        
        // Start transition - fade out current view
        withAnimation(.easeOut(duration: 0.15)) {
            isChangingView = true
        }
        
        // First close the menu
        withAnimation {
            showMenu = false
        }
        
        // Then switch tabs after a small delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            selectedTab = tab
            
            // Fade in the new view
            withAnimation(.easeIn(duration: 0.25)) {
                isChangingView = false
            }
        }
    }
    
    // Theme Selector View
    struct ThemeSelector: View {
        @EnvironmentObject private var themeManager: ThemeManager
        @State private var showThemes = false
        
        var body: some View {
            VStack(alignment: .leading) {
                Button {
                    withAnimation {
                        showThemes.toggle()
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "paintbrush.fill")
                            .font(.title3)
                            .frame(width: 30)
                        
                        Text("Theme")
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: showThemes ? "chevron.up" : "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(themeManager.textColor)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                }
                
                if showThemes {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(ThemeManager.AppTheme.allCases) { theme in
                            Button {
                                themeManager.currentTheme = theme
                            } label: {
                                HStack {
                                    Image(systemName: theme.icon)
                                        .foregroundColor(themeColor(for: theme))
                                    
                                    Text(theme.rawValue)
                                        .font(.subheadline)
                                    
                                    Spacer()
                                    
                                    if themeManager.currentTheme == theme {
                                        Image(systemName: "checkmark")
                                            .font(.caption)
                                    }
                                }
                                .foregroundColor(themeManager.textColor)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 15)
                                .padding(.leading, 20)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial.opacity(0.4))
                    .cornerRadius(10)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                }
            }
        }
        
        private func themeColor(for theme: ThemeManager.AppTheme) -> Color {
            switch theme {
            case .blue: return Color(hex: "1a73e8")
            case .dark: return Color(hex: "424242")
            case .light: return Color(hex: "BDBDBD")
            case .red: return Color(hex: "E53935")
            case .brown: return Color(hex: "8D6E63")
            case .green: return Color(hex: "43A047")
            }
        }
    }
    
    // Wrapper views
    struct AnalyticsWrapper: View {
        var dashboardViewModel: OwnerDashboardViewViewModel
        @EnvironmentObject private var themeManager: ThemeManager
        
        var body: some View {
            OwnerAnalyticsView(viewModel: dashboardViewModel)
                .environmentObject(themeManager)
        }
    }
    
    struct MenuWrapper: View {
        @EnvironmentObject private var themeManager: ThemeManager
        
        var body: some View {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
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
                
                // Important: Explicitly pass themeManager to OwnerMenuView
                OwnerMenuView()
                    .environmentObject(themeManager)
            }
        }
    }
    
    struct OrdersWrapper: View {
        @EnvironmentObject private var themeManager: ThemeManager
        
        var body: some View {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
                // Explicitly pass themeManager to OwnerOrdersView
                OwnerOrdersView()
                    .environmentObject(themeManager)
            }
        }
    }
    
    struct ReservationsWrapper: View {
        @EnvironmentObject private var themeManager: ThemeManager
        
        var body: some View {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
                // Explicitly pass themeManager to OwnerReservationsView
                OwnerReservationsView()
                    .environmentObject(themeManager)
            }
        }
    }
    
    struct MarketingWrapper: View {
        @EnvironmentObject private var themeManager: ThemeManager
        
        var body: some View {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
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
                
                // Explicitly pass themeManager to OwnerMarketingView
                OwnerMarketingView()
                    .environmentObject(themeManager)
            }
        }
    }
    
    struct SettingsWrapper: View {
        @EnvironmentObject private var themeManager: ThemeManager
        
        var body: some View {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
                // Explicitly pass themeManager to OwnerSettingsView
                OwnerSettingsView()
                    .environmentObject(themeManager)
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
