//
//  OrderView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI
import PassKit

enum OrderMode {
    case shop
    case subscription
}

struct SubscriptionPlan: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let frequency: String
    let benefits: [String]
    let imageName: String
}

struct OrderView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var cart: [OrderItem] = []
    @State private var orderMode: OrderMode = .shop
    @State private var showingCheckout = false
    @State private var selectedItem: MenuItem? = nil
    @Environment(\.colorScheme) private var colorScheme
    
    // Sample subscription plans
    private let subscriptionPlans = [
        SubscriptionPlan(
            id: UUID(),
            name: "Monthly Foodie",
            description: "Perfect for regular diners",
            price: 59.99,
            frequency: "Monthly",
            benefits: ["Free delivery on all orders", "10% off every order", "Early access to new menu items", "Priority reservations"],
            imageName: "subscription_basic"
        ),
        SubscriptionPlan(
            id: UUID(),
            name: "Gourmet Explorer",
            description: "For the true food enthusiasts",
            price: 99.99,
            frequency: "Monthly",
            benefits: ["Free delivery on all orders", "15% off every order", "Monthly exclusive chef's tasting", "VIP reservations", "Quarterly cooking class"],
            imageName: "subscription_premium"
        )
    ]
    
    // Add this function to OrderView
    private func handleSubscription(_ plan: SubscriptionPlan) {
        // Here you would typically:
        // 1. Show a confirmation alert
        // 2. Process the subscription
        // 3. Handle success/failure
        print("Subscribing to plan: \(plan.name)")
        // Add your subscription logic here
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                themeManager.backgroundGradient.ignoresSafeArea()
                
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
                
                VStack(spacing: 0) {
                    modeSelector
                    
                    if orderMode == .shop {
                        menuContent
                    } else {
                        subscriptionContent
                    }
                    
                    if !cart.isEmpty && orderMode == .shop {
                        cartSummary
                    }
                }
            }
            .navigationTitle("Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Order")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .sheet(isPresented: $showingCheckout) {
                CheckoutView(
                    cart: $cart,
                    onDismiss: { showingCheckout = false },
                    onPayment: {
                        // Handle successful payment
                        cart.removeAll()
                        showingCheckout = false
                    }
                )
                .environmentObject(themeManager)
            }
            .sheet(item: $selectedItem) { item in
                OrderItemDetailView(
                    item: item,
                    onAdd: { orderItem in
                        cart.append(orderItem)
                    }
                )
                .environmentObject(themeManager)
            }
        }
    }
    
    private var modeSelector: some View {
        Picker("Order Mode", selection: $orderMode) {
            Text("Shop").tag(OrderMode.shop)
            Text("Subscribe").tag(OrderMode.subscription)
        }
        .pickerStyle(.segmented)
        .padding()
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
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var menuContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(restaurant.menuCategories) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal)
                        
                        ForEach(category.items) { item in
                            MenuItemRow(item: item) {
                                selectedItem = item
                            }
                            .environmentObject(themeManager)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    private var subscriptionContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(subscriptionPlans) { plan in
                    SubscriptionPlanCard(plan: plan) {
                        // Handle subscription action
                        handleSubscription(plan)
                    }
                    .environmentObject(themeManager)
                }
            }
            .padding()
        }
    }
    
    private var cartSummary: some View {
        VStack(spacing: 0) {
            Divider()
                .background(themeManager.textColor.opacity(0.2))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(totalItems) \(totalItems == 1 ? "item" : "items")")
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor.opacity(0.8))
                    
                    Text("$\(String(format: "%.2f", cartTotal))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(themeManager.primaryColor.opacity(0.9))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                }
                
                Spacer()
                
                Button {
                    showingCheckout = true
                } label: {
                    Text("Checkout")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(themeManager.primaryColor)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                }
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }
    
    private var totalItems: Int {
        cart.reduce(0) { $0 + $1.quantity }
    }
    
    private var cartTotal: Double {
        cart.reduce(0) { total, item in
            let itemTotal = item.menuItem.price * Double(item.quantity)
            let customizationsTotal = item.customizations.compactMap { $0.selectedOption?.price }.reduce(0, +)
            return total + (itemTotal + customizationsTotal) * Double(item.quantity)
        }
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    let onTap: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(item.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                        .lineLimit(2)
                    
                    Text("$\(String(format: "%.2f", item.price))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(themeManager.primaryColor.opacity(0.9))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor.opacity(0.5))
            }
            .padding()
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
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
        }
    }
}

struct SubscriptionPlanCard: View {
    let plan: SubscriptionPlan
    let onSubscribe: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(plan.description)
                        .font(.subheadline)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
                
                Spacer()
                
                Image(plan.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(themeManager.primaryColor, lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            
            // Price
            HStack(alignment: .firstTextBaseline) {
                Text("$\(String(format: "%.2f", plan.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.textColor)
                
                Text(plan.frequency)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
            }
            
            // Benefits
            VStack(alignment: .leading, spacing: 8) {
                Text("Benefits:")
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                
                ForEach(plan.benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(themeManager.primaryColor)
                            .font(.subheadline)
                        
                        Text(benefit)
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor.opacity(0.8))
                    }
                }
            }
            
            // Subscribe button
            Button(action: onSubscribe) {
                Text("Subscribe Now")
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.primaryColor.opacity(0.85))
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

struct OrderItemDetailView: View {
    let item: MenuItem
    let onAdd: (OrderItem) -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var specialInstructions = ""
    @State private var selectedCustomizations: [Customization] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient from ThemeManager
                themeManager.backgroundGradient
                    .ignoresSafeArea()
                
                // Decorative elements
                decorativeCircles
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        itemImageSection
                        itemDetailsSection
                        quantitySelectorSection
                        specialInstructionsSection
                        addToCartButton
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(item.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
        }
    }
    
    // MARK: - Subviews
    
    private var decorativeCircles: some View {
        ZStack {
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
        }
    }
    
    private var itemImageSection: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(height: 200)
            .clipped()
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
    
    private var itemDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
            
            Text(item.description)
                .font(.body)
                .foregroundColor(themeManager.textColor.opacity(0.8))
            
            priceTag
        }
        .padding(.horizontal)
    }
    
    private var priceTag: some View {
        Text("$\(String(format: "%.2f", item.price))")
            .font(.headline)
            .foregroundColor(themeManager.textColor)
            .fontWeight(.bold)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(themeManager.primaryColor.opacity(0.9))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
            )
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
    private var quantitySelectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quantity")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            HStack {
                Button {
                    if quantity > 1 {
                        quantity -= 1
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(themeManager.primaryColor)
                }
                
                Text("\(quantity)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .frame(minWidth: 40)
                
                Button {
                    quantity += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(themeManager.primaryColor)
                }
            }
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
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private var specialInstructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Special Instructions")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $specialInstructions)
                    .frame(minHeight: 100)
                    .padding(10)
                    .background(themeManager.primaryColor.opacity(0.85))
                    .cornerRadius(8)
                    .foregroundColor(themeManager.textColor)
                    .scrollContentBackground(.hidden)
                
                if specialInstructions.isEmpty {
                    Text("Add any special requests or dietary restrictions...")
                        .foregroundColor(themeManager.textColor.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .allowsHitTesting(false)
                }
            }
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
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private var addToCartButton: some View {
        Button {
            let orderItem = OrderItem(
                id: UUID(),
                menuItem: item,
                quantity: quantity,
                customizations: selectedCustomizations,
                specialInstructions: specialInstructions
            )
            onAdd(orderItem)
            dismiss()
        } label: {
            Text("Add to Order - $\(String(format: "%.2f", item.price * Double(quantity)))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.primaryColor.opacity(0.9))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    private var toolbarContent: some ToolbarContent {
        Group {
            ToolbarItem(placement: .principal) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(themeManager.textColor)
            }
        }
    }
}

struct CheckoutView: View {
    @Binding var cart: [OrderItem]
    let onDismiss: () -> Void
    let onPayment: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Add payment processing states
    @State private var isProcessingPayment = false
    @State private var showingPaymentError = false
    @State private var showingPaymentSuccess = false
    @State private var paymentErrorMessage = ""
    
    @State private var deliveryAddress = ""
    @State private var deliveryInstructions = ""
    @State private var selectedPickupTime = Date()
    @State private var customerName = ""
    @State private var customerPhone = ""
    @State private var customerEmail = ""
    @State private var orderType: OrderType = .pickup
    
    private var subtotal: Double {
        cart.reduce(0) { total, item in
            let itemTotal = item.menuItem.price * Double(item.quantity)
            let customizationsTotal = item.customizations.compactMap { $0.selectedOption?.price }.reduce(0, +)
            return total + (itemTotal + customizationsTotal) * Double(item.quantity)
        }
    }
    
    private var tax: Double {
        subtotal * 0.08 // 8% tax rate
    }
    
    private var deliveryFee: Double {
        orderType == .delivery ? 5.99 : 0
    }
    
    private var total: Double {
        subtotal + tax + deliveryFee
    }
    
    private var totalItems: Int {
        cart.reduce(0) { $0 + $1.quantity }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Order Items Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Order Summary (\(totalItems) \(totalItems == 1 ? "item" : "items"))")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 16) {
                                ForEach(cart, id: \.id) { item in
                                    OrderItemRow(item: item) {
                                        if let index = cart.firstIndex(where: { $0.id == item.id }) {
                                            cart.remove(at: index)
                                        }
                                    }
                                    .environmentObject(themeManager)
                                }
                                
                                // Price breakdown
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Subtotal")
                                            .foregroundColor(themeManager.textColor.opacity(0.8))
                                        Spacer()
                                        Text("$\(String(format: "%.2f", subtotal))")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(themeManager.primaryColor.opacity(0.9))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                                            )
                                            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                                    }
                                    
                                    HStack {
                                        Text("Tax")
                                            .foregroundColor(themeManager.textColor.opacity(0.8))
                                        Spacer()
                                        Text("$\(String(format: "%.2f", tax))")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(themeManager.primaryColor.opacity(0.9))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                                            )
                                            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                                    }
                                    
                                    if orderType == .delivery {
                                        HStack {
                                            Text("Delivery Fee")
                                                .foregroundColor(themeManager.textColor.opacity(0.8))
                                            Spacer()
                                            Text("$\(String(format: "%.2f", deliveryFee))")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(themeManager.primaryColor.opacity(0.9))
                                                .cornerRadius(8)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                                                )
                                                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                                        }
                                    }
                                    
                                    Divider().background(themeManager.textColor.opacity(0.2))
                                    
                                    HStack {
                                        Text("Total")
                                            .font(.headline)
                                            .foregroundColor(themeManager.textColor)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", total))")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(themeManager.primaryColor.opacity(0.9))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                                            )
                                            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                                    }
                                }
                            }
                            .padding()
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
                            .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                            .padding(.horizontal)
                        }
                        .padding(.top, 16)
                        
                        // Order Type Selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Order Method")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 16)
                            
                            Picker("Order Type", selection: $orderType) {
                                Text("Pickup").tag(OrderType.pickup)
                                Text("Delivery").tag(OrderType.delivery)
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                            
                            if orderType == .pickup {
                                DatePicker("Pickup Time", selection: $selectedPickupTime, displayedComponents: [.date, .hourAndMinute])
                                    .foregroundColor(themeManager.textColor)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 12) {
                                    ZStack(alignment: .leading) {
                                        TextField("", text: $deliveryAddress)
                                            .padding(10)
                                            .background(themeManager.primaryColor.opacity(0.85))
                                            .cornerRadius(8)
                                            .foregroundColor(themeManager.textColor)
                                        
                                        if deliveryAddress.isEmpty {
                                            Text("Delivery Address")
                                                .foregroundColor(themeManager.textColor.opacity(0.6))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .allowsHitTesting(false)
                                        }
                                    }
                                    
                                    ZStack(alignment: .leading) {
                                        TextField("", text: $deliveryInstructions)
                                            .padding(10)
                                            .background(themeManager.primaryColor.opacity(0.85))
                                            .cornerRadius(8)
                                            .foregroundColor(themeManager.textColor)
                                        
                                        if deliveryInstructions.isEmpty {
                                            Text("Delivery Instructions (Optional)")
                                                .foregroundColor(themeManager.textColor.opacity(0.6))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .allowsHitTesting(false)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical, 12)
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
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                        
                        // Contact Information
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Information")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 12) {
                                ZStack(alignment: .leading) {
                                    TextField("", text: $customerName)
                                        .padding(10)
                                        .background(themeManager.primaryColor.opacity(0.85))
                                        .cornerRadius(8)
                                        .foregroundColor(themeManager.textColor)
                                        .textContentType(.name)
                                    
                                    if customerName.isEmpty {
                                        Text("Full Name")
                                            .foregroundColor(themeManager.textColor.opacity(0.6))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .allowsHitTesting(false)
                                    }
                                }
                                
                                ZStack(alignment: .leading) {
                                    TextField("", text: $customerPhone)
                                        .padding(10)
                                        .background(themeManager.primaryColor.opacity(0.85))
                                        .cornerRadius(8)
                                        .foregroundColor(themeManager.textColor)
                                        .textContentType(.telephoneNumber)
                                        .keyboardType(.phonePad)
                                    
                                    if customerPhone.isEmpty {
                                        Text("Phone Number")
                                            .foregroundColor(themeManager.textColor.opacity(0.6))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .allowsHitTesting(false)
                                    }
                                }
                                
                                ZStack(alignment: .leading) {
                                    TextField("", text: $customerEmail)
                                        .padding(10)
                                        .background(themeManager.primaryColor.opacity(0.85))
                                        .cornerRadius(8)
                                        .foregroundColor(themeManager.textColor)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                    
                                    if customerEmail.isEmpty {
                                        Text("Email Address")
                                            .foregroundColor(themeManager.textColor.opacity(0.6))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 10)
                                            .allowsHitTesting(false)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 12)
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
                        .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                        .padding(.horizontal)
                        
                        // Payment Section
                        if isProcessingPayment {
                            VStack(spacing: 16) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: themeManager.primaryColor))
                                    .scaleEffect(1.5)
                                
                                Text("Processing Payment...")
                                    .font(.headline)
                                    .foregroundColor(themeManager.textColor)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
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
                            .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                PaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black) {
                                    processPayment()
                                }
                                .frame(height: 50)
                                
                                Button {
                                    processPayment()
                                } label: {
                                    Text("Pay with Card")
                                        .font(.headline)
                                        .foregroundColor(themeManager.textColor)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(themeManager.primaryColor.opacity(0.2))
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
                                }
                                .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Checkout")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundColor(themeManager.textColor)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .alert("Payment Error", isPresented: $showingPaymentError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(paymentErrorMessage)
            }
            .alert("Payment Successful", isPresented: $showingPaymentSuccess) {
                Button("OK") {
                    onPayment() // This will trigger the success handler in OrderView
                }
            } message: {
                Text("Your order has been placed successfully! You will receive a confirmation email shortly.")
            }
        }
    }
    
    private func processPayment() {
        isProcessingPayment = true
        
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessingPayment = false
            showingPaymentSuccess = true // Show success alert instead of immediately dismissing
        }
    }
}

struct OrderItemRow: View {
    let item: OrderItem
    let onDelete: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(item.quantity)x")
                    .foregroundColor(themeManager.textColor.opacity(0.7))
                Text(item.menuItem.name)
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                Spacer()
                Text("$\(String(format: "%.2f", item.menuItem.price * Double(item.quantity)))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(themeManager.primaryColor.opacity(0.9))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            if !item.customizations.isEmpty {
                ForEach(item.customizations) { customization in
                    if let option = customization.selectedOption {
                        HStack {
                            Text("• \(customization.name): \(option.name)")
                                .font(.caption)
                                .foregroundColor(themeManager.textColor.opacity(0.7))
                            Spacer()
                            Text("+$\(String(format: "%.2f", option.price))")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(themeManager.primaryColor.opacity(0.9))
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
                        }
                    }
                }
            }
            
            if !item.specialInstructions.isEmpty {
                Text("Note: \(item.specialInstructions)")
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// Payment Button from PassKit
struct PaymentButton: UIViewRepresentable {
    let paymentButtonType: PKPaymentButtonType
    let paymentButtonStyle: PKPaymentButtonStyle
    let action: () -> Void
    
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: paymentButtonType, paymentButtonStyle: paymentButtonStyle)
        button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: PKPaymentButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}
