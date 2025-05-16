//
//  ContentView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/2/25.
//

import SwiftUI

struct CustomerView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @State private var showMenu: Bool = false
    @State private var selectedTab = Tab.home
    @State private var isChangingView = false // Track view change state
    
    enum Tab: String, CaseIterable {
        case home = "Home"
        case menu = "Menu"
        case reserve = "Reserve"
        case order = "Order"
        case info = "Info"
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .menu: return "menucard"
            case .reserve: return "calendar"
            case .order: return "bag"
            case .info: return "info.circle"
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
        // Create a tab bar with ultraThinMaterial and blue tint
        let appearance = UITabBarAppearance()
        
        // Start with a clean transparent background
        appearance.configureWithTransparentBackground()
        
        // Use ultraThinMaterial for the glassy effect
        appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
        
        // Add a semi-transparent blue tint
        appearance.backgroundColor = UIColor(Color(hex: "0d47a1").opacity(0.7))
        
        // Style the tab items
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply to all layout appearances for consistency
        appearance.inlineLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        appearance.inlineLayoutAppearance.selected.iconColor = .white
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        appearance.compactInlineLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        appearance.compactInlineLayoutAppearance.selected.iconColor = .white
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply this appearance to the tab bar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = .white
        
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
            NavigationStack {
                ZStack {
                    // Background gradient visible during transitions
                    backgroundGradient.ignoresSafeArea()
                    
                    // Main content with transitions
                    Group {
                        if selectedTab == .home {
                            HomeWrapper()
                                .transition(.opacity)
                        } else if selectedTab == .menu {
                            MenuWrapper()
                                .transition(.opacity)
                        } else if selectedTab == .reserve {
                            ReservationWrapper()
                                .transition(.opacity)
                        } else if selectedTab == .order {
                            OrderWrapper()
                                .transition(.opacity)
                        } else if selectedTab == .info {
                            InfoWrapper()
                                .transition(.opacity)
                        }
                    }
                    .opacity(isChangingView ? 0 : 1) // Fade out during transitions
                    
                    // Custom tab bar
                    .safeAreaInset(edge: .bottom) {
                        CustomTabBar(selectedTab: $selectedTab, isChangingView: $isChangingView)
                            .background(.ultraThinMaterial)
                    }
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
                }
            }
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } background: {
            backgroundGradient.ignoresSafeArea()
        }
    }
    
    // Get the appropriate title for the selected tab
    private func getTitleForTab(_ tab: Tab) -> String {
        switch tab {
        case .home:
            return "Home"
        case .menu:
            return "\(restaurant.name) Menu"
        case .reserve:
            return "Make a Reservation"
        case .order:
            return "Order"
        case .info:
            return "About Us"
        }
    }
    
    // Custom tab bar
    struct CustomTabBar: View {
        @Binding var selectedTab: Tab
        @Binding var isChangingView: Bool
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
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
                        .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.5))
                    }
                }
            }
            .background(Color(hex: "0d47a1").opacity(0.7))
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
    
    // ContentView/After Login/Customer/CustomerView.swift
    // Update the SideBarMenuView function

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
                        handleSidebarTabSelection(tab)
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
            
            // Theme Selector
            ThemeSelector()
                .padding(.horizontal, 15)
                .padding(.bottom, 20)
            
            // Reviews Button
            NavigationLink(destination: ReviewsView()) {
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.title3)
                        .frame(width: 30)
                    
                    Text("Reviews")
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
    
    // Add the ThemeSelector view
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
                    .foregroundColor(.white)
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
                                .foregroundColor(.white)
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
    struct HomeWrapper: View {
        @EnvironmentObject private var restaurant: RestaurantConfiguration
        
        var body: some View {
            HomeView(onMenuButtonTap: nil) // No need for menu button in individual views
        }
    }
    
    struct MenuWrapper: View {
        var body: some View {
            MenuView()
        }
    }
    
    struct ReservationWrapper: View {
        var body: some View {
            ReservationView()
        }
    }
    
    struct OrderWrapper: View {
        var body: some View {
            OrderView()
        }
    }
    
    struct InfoWrapper: View {
        var body: some View {
            InfoView()
        }
    }
}
