import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    
    // Sample data - in a real app, you'd load this from a database/API
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
    @State private var showingFullMenu = true  // Set to true by default
    
    // Animation state
    @Namespace private var menuAnimation
    
    var body: some View {
        NavigationStack {
            menuContent
        }
        .onAppear {
            if selectedCategory == nil {
                selectedCategory = categories.first
            }
        }
    }
    
    // MARK: - Content Views
    
    private var menuContent: some View {
        ZStack(alignment: .top) {
            // Background
            Color(.systemGroupedBackground).ignoresSafeArea()
            
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
        }
        .navigationTitle("\(restaurant.name) Menu")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingItemDetail) {
            if let item = selectedItem {
                MenuItemDetailView(item: item)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
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
        .background(Color(.systemBackground))
        .shadow(radius: 5)
    }
    
    private var categoryTitle: some View {
        Text(selectedCategory?.name ?? categories.first?.name ?? "Menu")
            .font(.title2)
            .fontWeight(.bold)
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
        List {
            ForEach(categories) { category in
                Section(header: Text(category.name).font(.headline)) {
                    ForEach(category.items) { item in
                        FullMenuItemRow(item: item)
                            .onTapGesture {
                                selectedItem = item
                                showingItemDetail = true
                            }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
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
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(Color.primary)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .padding(.bottom, 4)
    }
}

// Full menu item row for the list view
struct FullMenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack(spacing: 24) {
            // Image
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 3)
            
            // Item details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
            // Price
            Text("$\(String(format: "%.2f", item.price))")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.leading, 4)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
}

// Component for category selection buttons
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
                    .foregroundColor(isSelected ? .primary : .secondary)
                
                // Indicator line
                if isSelected {
                    Rectangle()
                        .fill(Color.primary)
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
    }
}

// Card view for displaying a menu item
struct MenuItemCard: View {
    let item: MenuItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            imageWithPriceTag
            
            // Info
            itemInfo
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
    
    private var imageWithPriceTag: some View {
        ZStack(alignment: .topTrailing) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .clipped()
                .cornerRadius(16)
            
            // Price tag
            HStack(spacing: 2) {
                Text("$")
                    .font(.caption.bold())
                    .foregroundColor(.primary.opacity(0.7))
                
                Text(String(format: "%.2f", item.price))
                    .font(.system(.body, design: .rounded).bold())
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white)
                    .shadow(radius: 3)
            )
            .padding(10)
        }
    }
    
    private var itemInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(item.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 12)
    }
}

// Detail view for a menu item
struct MenuItemDetailView: View {
    let item: MenuItem
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Hero image
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
                        .shadow(radius: 5)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(item.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Divider()
                        
                        HStack {
                            Text("Quantity")
                                .font(.headline)
                            
                            Spacer()
                            
                            HStack(spacing: 18) {
                                Button {
                                    if quantity > 1 {
                                        quantity -= 1
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(quantity > 1 ? .primary : .gray)
                                }
                                .shadow(radius: 2)
                                
                                Text("\(quantity)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .frame(minWidth: 30)
                                
                                Button {
                                    if quantity < 10 {
                                        quantity += 1
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }
                                .shadow(radius: 2)
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
                                .background(Color.primary)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 16)
                    }
                    .padding()
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                    }
                }
            }
        }
    }
}

// Make MenuCategory conform to Equatable
extension MenuCategory: Equatable {
    static func == (lhs: MenuCategory, rhs: MenuCategory) -> Bool {
        return lhs.id == rhs.id
    }
}
