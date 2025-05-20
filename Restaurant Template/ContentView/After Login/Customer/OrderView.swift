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
    @State private var showingPaymentSheet = false
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
                    onPayment: { showingPaymentSheet = true }
                )
                .environmentObject(themeManager)
            }
            .sheet(isPresented: $showingPaymentSheet) {
                PaymentView(
                    amount: cartTotal,
                    onDismiss: { showingPaymentSheet = false },
                    onSuccess: handlePaymentSuccess
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
            LazyVStack(spacing: 20) {
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
                    .padding(.vertical, 8)
                }
            }
            .padding(.vertical)
        }
    }
    
    private var subscriptionContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(subscriptionPlans) { plan in
                    SubscriptionPlanCard(plan: plan) {
                        showingCheckout = true
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
                        .foregroundColor(themeManager.textColor)
                }
                
                Spacer()
                
                Button {
                    showingCheckout = true
                } label: {
                    Text("Checkout")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(themeManager.primaryColor.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
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
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .padding()
            .background(.ultraThinMaterial)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
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
    
    private func handlePaymentSuccess() {
        cart = []
        showingPaymentSheet = false
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    let onAdd: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
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
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.primaryColor)
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(themeManager.primaryColor)
            }
        }
        .padding(.horizontal)
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
        .padding(.horizontal)
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
                    .foregroundColor(themeManager.primaryColor)
                
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
                    VStack(alignment: .leading, spacing: 20) {
                        // Item image
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                        VStack(alignment: .leading, spacing: 12) {
                            // Item details
                            Text(item.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.textColor)
                            
                            Text(item.description)
                                .font(.body)
                                .foregroundColor(themeManager.textColor.opacity(0.8))
                            
                            Text("$\(String(format: "%.2f", item.price))")
                                .font(.headline)
                                .foregroundColor(themeManager.primaryColor)
                        }
                        .padding(.horizontal)
                        
                        // Quantity selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quantity")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            HStack(spacing: 20) {
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
                                    .frame(minWidth: 30)
                                
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
                        
                        // Special instructions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Special Instructions")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            ZStack(alignment: .topLeading) {
                                TextField("Add note (optional)", text: $specialInstructions, axis: .vertical)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .lineLimit(3)
                                
                                if specialInstructions.isEmpty {
                                    Text("Add note (optional)")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .allowsHitTesting(false)
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
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add to Cart") {
                        let orderItem = OrderItem(
                            id: UUID(),
                            menuItem: item,
                            quantity: quantity,
                            customizations: selectedCustomizations,
                            specialInstructions: specialInstructions
                        )
                        onAdd(orderItem)
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
        }
    }
}

struct CheckoutView: View {
    @Binding var cart: [OrderItem]
    let onDismiss: () -> Void
    let onPayment: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
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
                                ForEach(cart) { item in
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
                                            .foregroundColor(themeManager.textColor)
                                    }
                                    
                                    HStack {
                                        Text("Tax")
                                            .foregroundColor(themeManager.textColor.opacity(0.8))
                                        Spacer()
                                        Text("$\(String(format: "%.2f", tax))")
                                            .foregroundColor(themeManager.textColor)
                                    }
                                    
                                    if orderType == .delivery {
                                        HStack {
                                            Text("Delivery Fee")
                                                .foregroundColor(themeManager.textColor.opacity(0.8))
                                            Spacer()
                                            Text("$\(String(format: "%.2f", deliveryFee))")
                                                .foregroundColor(themeManager.textColor)
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
                                            .foregroundColor(themeManager.primaryColor)
                                    }
                                }
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
                                .padding(.horizontal)
                            }
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
                                    TextField("Delivery Address", text: $deliveryAddress)
                                        .padding(10)
                                        .background(themeManager.primaryColor.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    TextField("Delivery Instructions (Optional)", text: $deliveryInstructions)
                                        .padding(10)
                                        .background(themeManager.primaryColor.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(themeManager.textColor)
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Contact Information
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Information")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 12) {
                                TextField("Full Name", text: $customerName)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                
                                TextField("Phone Number", text: $customerPhone)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .keyboardType(.phonePad)
                                
                                TextField("Email Address", text: $customerEmail)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .autocorrectionDisabled()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // Payment Button
                        Button {
                            onPayment()
                        } label: {
                            Text("Proceed to Payment - $\(String(format: "%.2f", total))")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormValid ? themeManager.primaryColor.opacity(0.2) : Color.gray.opacity(0.2))
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
                        .disabled(!isFormValid)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                    }
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        onDismiss()
                    }
                    .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
        }
    }
    
    private var isFormValid: Bool {
        let hasValidContactInfo = !customerName.isEmpty && !customerPhone.isEmpty && !customerEmail.isEmpty
        
        if orderType == .delivery {
            return hasValidContactInfo && !deliveryAddress.isEmpty
        } else {
            return hasValidContactInfo
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
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.primaryColor)
                
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
                                .foregroundColor(themeManager.textColor.opacity(0.7))
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
    }
}

struct PaymentView: View {
    let amount: Double
    let onDismiss: () -> Void
    let onSuccess: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var isProcessing = false
    @State private var paymentSuccess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.backgroundGradient.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    if isProcessing {
                        processingView
                    } else if paymentSuccess {
                        successView
                    } else {
                        paymentMethodsView
                    }
                }
                .padding()
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !paymentSuccess {
                        Button("Cancel") {
                            onDismiss()
                        }
                        .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                    }
                }
            }
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
        }
    }
    
    private var paymentMethodsView: some View {
        VStack(spacing: 40) {
            Text("Total Amount: $\(String(format: "%.2f", amount))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
            
            VStack(spacing: 16) {
                PaymentMethodButton(title: "Credit / Debit Card", icon: "creditcard.fill") {
                    processPayment()
                }
                .environmentObject(themeManager)
                
                PaymentMethodButton(title: "Apple Pay", icon: "apple.logo") {
                    processPayment()
                }
                .environmentObject(themeManager)
                
                PaymentMethodButton(title: "PayPal", icon: "p.circle.fill") {
                    processPayment()
                }
                .environmentObject(themeManager)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "shield.checkerboard")
                        .foregroundColor(themeManager.primaryColor)
                    Text("Secure Payment")
                        .font(.footnote)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
                
                Text("Your payment information is encrypted and secure")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.textColor.opacity(0.5))
            }
            .padding(.top, 20)
        }
    }
    
    private var processingView: some View {
        VStack(spacing: 40) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(themeManager.primaryColor)
            
            Text("Processing Payment...")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textColor)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isProcessing = false
                paymentSuccess = true
            }
        }
    }
    
    private var successView: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(themeManager.primaryColor)
            
            Text("Payment Successful!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
            
            Text("Thank you for your order!")
                .font(.headline)
                .foregroundColor(themeManager.textColor.opacity(0.7))
            
            Text("Your order has been placed and is being prepared.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.textColor.opacity(0.7))
            
            Button {
                onSuccess()
            } label: {
                Text("Return to Menu")
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.primaryColor.opacity(0.2))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
            }
            .padding(.top, 20)
        }
    }
    
    private func processPayment() {
        isProcessing = true
    }
}

struct PaymentMethodButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(themeManager.primaryColor)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(themeManager.textColor.opacity(0.5))
            }
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
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
            .environmentObject(RestaurantConfiguration.shared)
            .environmentObject(ThemeManager())
    }
}
