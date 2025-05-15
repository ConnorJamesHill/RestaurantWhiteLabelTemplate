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
    
    // Update the init() method with this simpler approach:

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
                // Update the TabView to ensure each tab has proper navigation title:

                TabView(selection: $selectedTab) {
                    HomeView(onMenuButtonTap: {
                        withAnimation {
                            showMenu.toggle()
                        }
                    })
                    .tag(Tab.home)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .navigationTitle("Home")
                    
                    MenuView()
                        .tag(Tab.menu)
                        .tabItem {
                            Label("Menu", systemImage: "menucard")
                        }
                        .navigationTitle("\(restaurant.name) Menu")
                    
                    ReservationView()
                        .tag(Tab.reserve)
                        .tabItem {
                            Label("Reserve", systemImage: "calendar")
                        }
                        .navigationTitle("Make a Reservation")
                    
                    OrderView()
                        .tag(Tab.order)
                        .tabItem {
                            Label("Order", systemImage: "bag")
                        }
                        .navigationTitle("Order")
                    
                    InfoView()
                        .tag(Tab.info)
                        .tabItem {
                            Label("Info", systemImage: "info.circle")
                        }
                        .navigationTitle("About Us")
                }
                .tint(.white)
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: selectedTab) { oldValue, newValue in
                    // Ensure the navigation title is updated when tab changes
                    switch newValue {
                    case .home:
                        UINavigationBar.appearance().topItem?.title = "Home"
                    case .menu:
                        UINavigationBar.appearance().topItem?.title = "\(restaurant.name) Menu"
                    case .reserve:
                        UINavigationBar.appearance().topItem?.title = "Make a Reservation"
                    case .order:
                        UINavigationBar.appearance().topItem?.title = "Order"
                    case .info:
                        UINavigationBar.appearance().topItem?.title = "About Us"
                    }
                }
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
                }
                // Add this to the TabView in the body
                .onAppear {
                    // Force tab bar appearance when view appears
                    DispatchQueue.main.async {
                        let appearance = UITabBarAppearance()
                        
                        // Start with transparent background for material effect
                        appearance.configureWithTransparentBackground()
                        
                        // Apply ultraThinMaterial effect
                        appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
                        
                        // Create a gradient-like effect with a semi-transparent overlay
                        // Top color: lighter blue
                        let topColor = UIColor(Color(hex: "1a73e8").opacity(0.85))
                        // Bottom color: darker blue
                        let bottomColor = UIColor(Color(hex: "002171").opacity(0.85))
                        
                        // Use the average color for the backgroundColor with material effect
                        appearance.backgroundColor = UIColor(
                            red: (topColor.cgColor.components![0] + bottomColor.cgColor.components![0]) / 2,
                            green: (topColor.cgColor.components![1] + bottomColor.cgColor.components![1]) / 2,
                            blue: (topColor.cgColor.components![2] + bottomColor.cgColor.components![2]) / 2,
                            alpha: 0.85
                        )
                        
                        // Style the tab items
                        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
                        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
                        appearance.stackedLayoutAppearance.selected.iconColor = .white
                        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
                        
                        // Apply this appearance to the tab bar
                        UITabBar.appearance().standardAppearance = appearance
                        UITabBar.appearance().scrollEdgeAppearance = appearance
                        UITabBar.appearance().tintColor = .white
                        
                        // Enhance the tab bar with a subtle border
                        UITabBar.appearance().layer.borderWidth = 0.2
                        UITabBar.appearance().layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
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
    
    // Update the SideBarMenuView method in CustomerView:

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
                        // Set the selected tab when clicked
                        selectedTab = tab
                        
                        // Close the side menu with animation
                        withAnimation {
                            showMenu = false
                        }
                        
                        // Ensure the navigation title is preserved
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            // Force navigation title update based on selected tab
                            switch tab {
                            case .home:
                                UINavigationBar.appearance().topItem?.title = "Home"
                            case .menu:
                                UINavigationBar.appearance().topItem?.title = "\(restaurant.name) Menu"
                            case .reserve:
                                UINavigationBar.appearance().topItem?.title = "Make a Reservation"
                            case .order:
                                UINavigationBar.appearance().topItem?.title = "Order"
                            case .info:
                                UINavigationBar.appearance().topItem?.title = "About Us"
                            }
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
}
