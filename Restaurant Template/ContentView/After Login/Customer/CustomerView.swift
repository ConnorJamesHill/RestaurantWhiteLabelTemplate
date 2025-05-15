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
    
    init() {
        // Create a blue gradient for the tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // Use opaque instead of transparent
        
        // Use a visual effect with blue tint
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        appearance.backgroundEffect = blurEffect
        
        // Add a blue overlay color - make it stronger
        appearance.backgroundColor = UIColor(Color(hex: "0d47a1"))
        
        // Use this appearance for the tab bar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // Set the unselected icons to white with reduced opacity
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        
        // Set the selected icons to full white
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply to ALL layout appearances
        appearance.inlineLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        appearance.inlineLayoutAppearance.selected.iconColor = .white
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        appearance.compactInlineLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.5)
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        appearance.compactInlineLayoutAppearance.selected.iconColor = .white
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Force the tab bar tint to white
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
                    
                    MenuView()
                        .tag(Tab.menu)
                        .tabItem {
                            Label("Menu", systemImage: "menucard")
                        }
                    
                    ReservationView()
                        .tag(Tab.reserve)
                        .tabItem {
                            Label("Reserve", systemImage: "calendar")
                        }
                    
                    OrderView()
                        .tag(Tab.order)
                        .tabItem {
                            Label("Order", systemImage: "bag")
                        }
                    
                    InfoView()
                        .tag(Tab.info)
                        .tabItem {
                            Label("Info", systemImage: "info.circle")
                        }
                }
                .tint(.white) // Add this line to make icons white
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
                }
                .onAppear {
                    // Force tab bar appearance when view appears
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
                    appearance.backgroundColor = UIColor(Color(hex: "0d47a1"))
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                    UITabBar.appearance().tintColor = .white
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
