//
//  MenuView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager

    @State private var categories = [
        MenuCategory(id: UUID(), name: "Appetizers", items: [
            MenuItem(id: UUID(), name: "Mozzarella Sticks", description: "Crispy, golden-brown mozzarella sticks served with marinara sauce.", price: 8.99, imageName: "mozzarella_sticks"),
            MenuItem(id: UUID(), name: "Spinach Artichoke Dip", description: "Creamy spinach and artichoke dip served with tortilla chips.", price: 9.99, imageName: "spinach_dip")
        ]),
        MenuCategory(id: UUID(), name: "Main Courses", items: [
            MenuItem(id: UUID(), name: "Classic Burger", description: "Juicy beef patty with lettuce, tomato, and special sauce on a brioche bun.", price: 12.99, imageName: "burger"),
            MenuItem(id: UUID(), name: "Margherita Pizza", description: "Traditional pizza with tomato sauce, fresh mozzarella, and basil.", price: 14.99, imageName: "pizza")
        ]),
        MenuCategory(id: UUID(), name: "Desserts", items: [
            MenuItem(id: UUID(), name: "Chocolate Cake", description: "Rich, moist chocolate cake with a velvety ganache.", price: 6.99, imageName: "chocolate_cake"),
            MenuItem(id: UUID(), name: "Cheesecake", description: "Creamy New York-style cheesecake with a graham cracker crust.", price: 7.99, imageName: "cheesecake")
        ])
    ]

    @State private var selectedCategory: MenuCategory? = nil
    @State private var selectedItem: MenuItem? = nil
    @State private var showingFullMenu = true

    @Namespace private var menuAnimation

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background from ThemeManager
                themeManager.backgroundGradient.ignoresSafeArea()

                // Decorative blurred circles
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

                VStack(spacing: 0) {
                    categoriesScrollView
                    if showingFullMenu {
                        fullMenuList
                    } else {
                        categoryTitle
                        menuItemsGrid
                    }
                    viewToggleButton
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
            .navigationTitle("\(restaurant.name) Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("\(restaurant.name) Menu")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .sheet(item: $selectedItem) { item in
                MenuItemDetailView(item: item)
                    .environmentObject(themeManager)
                    .presentationDetents([.medium, .large])
            }
        }
        .onAppear {
            if selectedCategory == nil {
                selectedCategory = categories.first
            }
        }
    }

    // MARK: - Content Views

    private var categoriesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory?.id == category.id && !showingFullMenu,
                        namespace: menuAnimation,
                        action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategory = category
                                showingFullMenu = false
                            }
                        }
                    )
                    .environmentObject(themeManager)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    private var categoryTitle: some View {
        Text(selectedCategory?.name ?? categories.first?.name ?? "Menu")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(themeManager.textColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 24)
            .padding(.bottom, 8)
    }

    private var menuItemsGrid: some View {
        let currentItems = selectedCategory?.items ?? categories.first?.items ?? []
        let categoryId = selectedCategory?.id

        return ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 16)],
                spacing: 18
            ) {
                ForEach(currentItems) { item in
                    MenuItemCard(item: item)
                        .environmentObject(themeManager)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .padding(16)
            .animation(.bouncy(), value: categoryId)
        }
    }

    private var fullMenuList: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(categories) { category in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(category.name)
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        VStack(spacing: 16) {
                            ForEach(category.items) { item in
                                FullMenuItemRow(item: item)
                                    .environmentObject(themeManager)
                                    .onTapGesture {
                                        selectedItem = item
                                    }
                            }
                        }
                        .padding(.bottom, 8)
                    }
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.15
                            )
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .padding(.horizontal)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
    }

    private var viewToggleButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showingFullMenu.toggle()
                // Ensure a category is selected when switching to grid view
                if !showingFullMenu && selectedCategory == nil {
                    selectedCategory = categories.first
                }
            }
        }) {
            Text(showingFullMenu ? "Grid View" : "Full Menu")
                .foregroundColor(themeManager.textColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

struct CategoryButton: View {
    let category: MenuCategory
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Button(action: action) {
            Text(category.name)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.primaryColor.opacity(0.9))
                                .matchedGeometryEffect(id: "background", in: namespace)
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? themeManager.primaryColor : Color.clear,
                            lineWidth: 1.5
                        ).opacity(0.2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// For FullMenuItemRow (list view)
struct FullMenuItemRow: View {
    let item: MenuItem
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        HStack(spacing: 8) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text("$\(String(format: "%.2f", item.price))")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(8)
                .background(themeManager.primaryColor.opacity(0.9)) // Changed to primary color with high opacity
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 8)
    }
}

struct MenuItemCard: View {
    let item: MenuItem
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            imageWithPriceTag
            itemInfo
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private var imageWithPriceTag: some View {
        ZStack(alignment: .topTrailing) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipped()
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 16
                    )
                )

            HStack(spacing: 2) {
                Text("$")
                    .font(.caption.bold())
                    .foregroundColor(.white)
                Text(String(format: "%.2f", item.price))
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(themeManager.primaryColor.opacity(0.9)) // Changed to primary color with high opacity
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
            )
            .padding(10)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }

    private var itemInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .lineLimit(1)
            Text(item.description)
                .font(.caption)
                .foregroundColor(themeManager.textColor.opacity(0.7))
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 12)
    }
}

struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var quantity = 1

    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.4)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                            .overlay(
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text("$\(String(format: "%.2f", item.price))")
                                            .font(.headline)
                                            .foregroundColor(.white.opacity(0.9))
                                    }
                                    Spacer()
                                }
                                .padding(),
                                alignment: .bottomLeading
                            )

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            Text(item.description)
                                .font(.body)
                                .foregroundColor(themeManager.textColor.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                            Divider().background(themeManager.textColor.opacity(0.2))
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.15
                                )
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.textColor)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
        }
    }
}
