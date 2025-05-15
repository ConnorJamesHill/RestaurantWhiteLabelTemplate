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
        case settings = "Settings"
        
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
        UINavigationBar.appearance().compactAppearance = navBarAppearance
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
                TabView(selection: $selectedTab) {
                    // Dashboard Tab - Analytics
                    OwnerAnalyticsView(onMenuButtonTap: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    })
                    .tag(Tab.analytics)
                    .tabItem {
                        Label("Analytics", systemImage: "chart.bar.fill")
                    }
                    
                    // Menu Management Tab
                    OwnerMenuView()
                        .tag(Tab.menu)
                        .tabItem {
                            Label("Menu", systemImage: "doc.text.fill")
                        }
                    
                    // Orders Management Tab
                    OwnerOrdersView()
                        .tag(Tab.orders)
                        .tabItem {
                            Label("Orders", systemImage: "bag.fill")
                        }
                    
                    // Reservations Management Tab
                    OwnerReservationsView()
                        .tag(Tab.tables)
                        .tabItem {
                            Label("Tables", systemImage: "calendar")
                        }
                    
                    // Marketing & Promotions Tab
                    OwnerMarketingView()
                        .tag(Tab.marketing)
                        .tabItem {
                            Label("Marketing", systemImage: "megaphone.fill")
                        }
                    
                    // Settings & Account Tab
                    OwnerSettingsView()
                        .tag(Tab.settings)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
                .tint(.white) // Add this line to make icons white
                .navigationBarTitleDisplayMode(.inline) 
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if selectedTab != .analytics {
                            Button {
                                withAnimation {
                                    showMenu.toggle()
                                }
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.signOut()
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
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
            
            // Menu Items
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
