import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration

    // Blue gradient background
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
    @State private var showingItemDetail = false
    @State private var showingFullMenu = true

    @Namespace private var menuAnimation

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                backgroundGradient.ignoresSafeArea()

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
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $showingItemDetail) {
                if let item = selectedItem {
                    MenuItemDetailView(item: item)
                        .background(backgroundGradient.ignoresSafeArea())
                        .presentationDetents([.medium, .large])
                }
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
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
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
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var categoryTitle: some View {
        Text(selectedCategory?.name ?? categories.first?.name ?? "Menu")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
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
                        .onTapGesture {
                            selectedItem = item
                            withAnimation {
                                showingItemDetail = true
                            }
                        }
                }
            }
            .padding(16)
            .animation(.spring(response: 0.35), value: categoryId)
        }
    }

    private var fullMenuList: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(categories) { category in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(category.name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        VStack(spacing: 12) {
                            ForEach(category.items) { item in
                                FullMenuItemRow(item: item)
                                    .onTapGesture {
                                        selectedItem = item
                                        showingItemDetail = true
                                    }
                            }
                        }
                        .padding(.bottom, 8)
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
                    .padding(.horizontal)
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
    }

    private var viewToggleButton: some View {
        Button {
            withAnimation(.spring(response: 0.35)) {
                showingFullMenu.toggle()
            }
        } label: {
            HStack {
                Image(systemName: showingFullMenu ? "square.grid.2x2" : "list.bullet")
                Text(showingFullMenu ? "Grid View" : "Full Menu")
            }
            .font(.subheadline.bold())
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
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
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Supporting Views

struct FullMenuItemRow: View {
    let item: MenuItem

    var body: some View {
        HStack(spacing: 24) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text("$\(String(format: "%.2f", item.price))")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading, 4)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
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
        .padding(.horizontal, 4)
    }
}

struct CategoryButton: View {
    let category: MenuCategory
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(category.name)
                    .fontWeight(isSelected ? .bold : .medium)
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                if isSelected {
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "categoryIndicator", in: namespace)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 3)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 2)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.10), radius: 4, x: 0, y: 2)
    }
}

struct MenuItemCard: View {
    let item: MenuItem

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
                .cornerRadius(16)

            HStack(spacing: 2) {
                Text("$")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.7))
                Text(String(format: "%.2f", item.price))
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
            )
            .padding(10)
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }

    private var itemInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            Text(item.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
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
    @State private var quantity = 1

    // Use the same gradient as the main view
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

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient.ignoresSafeArea()
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
                                .foregroundColor(.white)
                            Text(item.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                            Divider().background(Color.white.opacity(0.2))
                            HStack {
                                Text("Quantity")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 18) {
                                    Button {
                                        if quantity > 1 { quantity -= 1 }
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(quantity > 1 ? .white : .gray)
                                    }
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    Text("\(quantity)")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 30)
                                    Button {
                                        if quantity < 10 { quantity += 1 }
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                            }
                            Button {
                                dismiss()
                            } label: {
                                Text("Add to Order - $\(String(format: "%.2f", item.price * Double(quantity)))")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
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
                            }
                            .padding(.top, 16)
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
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                }
            }
        }
    }
}
