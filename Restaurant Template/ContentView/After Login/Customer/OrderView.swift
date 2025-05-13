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
    @State private var cart: [OrderItem] = []
    @State private var orderMode: OrderMode = .shop
    @State private var showingCheckout = false
    @State private var showingPaymentSheet = false
    @State private var selectedItem: MenuItem? = nil
    @State private var showingItemDetail = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Enhanced blue gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"), // Vibrant blue
                Color(hex: "0d47a1"), // Deep blue
                Color(hex: "002171"), // Dark blue
                Color(hex: "002984")  // Navy blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private let subscriptionPlans = [
        SubscriptionPlan(
            id: UUID(),
            name: "Basic Plan",
            description: "Perfect for individuals",
            price: 49.99,
            frequency: "per month",
            benefits: [
                "3 meals per week",
                "Free delivery",
                "10% off all orders",
                "Priority support"
            ],
            imageName: "subscription_basic"
        ),
        SubscriptionPlan(
            id: UUID(),
            name: "Family Plan",
            description: "Great for families",
            price: 89.99,
            frequency: "per month",
            benefits: [
                "6 meals per week",
                "Free delivery",
                "15% off all orders",
                "Priority support",
                "Family meal planning"
            ],
            imageName: "subscription_family"
        ),
        SubscriptionPlan(
            id: UUID(),
            name: "Premium Plan",
            description: "For the ultimate experience",
            price: 129.99,
            frequency: "per month",
            benefits: [
                "Unlimited meals",
                "Free delivery",
                "20% off all orders",
                "24/7 priority support",
                "Exclusive menu items",
                "Monthly chef's special"
            ],
            imageName: "subscription_premium"
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
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
                
                VStack(spacing: 0) {
                    modeSelector
                    
                    if orderMode == .shop {
                        menuContent
                    } else {
                        subscriptionContent
                    }
                    
                    if !cart.isEmpty {
                        cartSummary
                    }
                }
            }
            .navigationTitle("Order Online")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $showingCheckout) {
                CheckoutView(
                    cart: $cart,
                    onDismiss: { showingCheckout = false },
                    onPayment: { showingPaymentSheet = true }
                )
            }
            .sheet(isPresented: $showingPaymentSheet) {
                PaymentView(
                    amount: cartTotal,
                    onDismiss: { showingPaymentSheet = false },
                    onSuccess: handlePaymentSuccess
                )
            }
            .sheet(item: $selectedItem) { item in
                OrderItemDetailView(
                    item: item,
                    onAdd: { orderItem in
                        cart.append(orderItem)
                    }
                )
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
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ForEach(category.items) { item in
                            MenuItemRow(item: item) {
                                selectedItem = item
                            }
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
                }
            }
            .padding()
        }
    }
    
    private var cartSummary: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.white.opacity(0.2))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(totalItems) \(totalItems == 1 ? "item" : "items")")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("$\(String(format: "%.2f", cartTotal))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Button {
                    showingCheckout = true
                } label: {
                    Text("Checkout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.2))
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
                    .foregroundColor(.white)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
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
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct SubscriptionPlanCard: View {
    let plan: SubscriptionPlan
    let onSubscribe: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plan.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(plan.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", plan.price))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(plan.frequency)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(plan.benefits, id: \.self) { benefit in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(benefit)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Button(action: onSubscribe) {
                Text("Subscribe Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
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
    }
}

// edit below

// ... existing code ...

struct OrderItemDetailView: View {
    let item: MenuItem
    let onAdd: (OrderItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var specialInstructions = ""
    @State private var selectedCustomizations: [Customization] = []
    
    // Enhanced blue gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"), // Vibrant blue
                Color(hex: "0d47a1"), // Deep blue
                Color(hex: "002171"), // Dark blue
                Color(hex: "002984")  // Navy blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
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
                                .foregroundColor(.white)
                            
                            Text(item.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("$\(String(format: "%.2f", item.price))")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        // Quantity selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Quantity")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 20) {
                                Button {
                                    if quantity > 1 {
                                        quantity -= 1
                                    }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                                
                                Text("\(quantity)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 30)
                                
                                Button {
                                    quantity += 1
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
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
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                TextField("Add note (optional)", text: $specialInstructions, axis: .vertical)
                                    .padding(10)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .lineLimit(3)
                                
                                if specialInstructions.isEmpty {
                                    Text("Add note (optional)")
                                        .foregroundColor(.white.opacity(0.6))
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
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
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
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct CheckoutView: View {
    @Binding var cart: [OrderItem]
    let onDismiss: () -> Void
    let onPayment: () -> Void
    
    @State private var deliveryAddress = ""
    @State private var deliveryInstructions = ""
    @State private var selectedPickupTime = Date()
    @State private var customerName = ""
    @State private var customerPhone = ""
    @State private var customerEmail = ""
    @State private var orderType: OrderType = .pickup
    
    // Enhanced blue gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"), // Vibrant blue
                Color(hex: "0d47a1"), // Deep blue
                Color(hex: "002171"), // Dark blue
                Color(hex: "002984")  // Navy blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
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
                // Background gradient
                backgroundGradient
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
                    VStack(spacing: 24) {
                        // Contact Information Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Information")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 12) {
                                TextField("Name", text: $customerName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("Phone", text: $customerPhone)
                                    .keyboardType(.phonePad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("Email", text: $customerEmail)
                                    .keyboardType(.emailAddress)
                                    .textContentType(.emailAddress)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            .padding(.horizontal)
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
                        
                        // Order Type Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Order Type")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 16) {
                                Picker("Delivery Method", selection: $orderType) {
                                    Text("Pickup").tag(OrderType.pickup)
                                    Text("Delivery").tag(OrderType.delivery)
                                }
                                .pickerStyle(.segmented)
                                .padding(.horizontal)
                                
                                if orderType == .delivery {
                                    VStack(spacing: 12) {
                                        TextField("Delivery Address", text: $deliveryAddress, axis: .vertical)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .lineLimit(3...6)
                                        
                                        TextField("Delivery Instructions (Optional)", text: $deliveryInstructions, axis: .vertical)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .lineLimit(2...4)
                                    }
                                    .padding(.horizontal)
                                } else {
                                    DatePicker(
                                        "Pickup Time",
                                        selection: $selectedPickupTime,
                                        in: Date()...,
                                        displayedComponents: [.hourAndMinute]
                                    )
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .colorScheme(.dark)
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
                        
                        // Order Summary Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Order Summary (\(totalItems) \(totalItems == 1 ? "item" : "items"))")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                            
                            VStack(spacing: 16) {
                                ForEach(cart) { item in
                                    OrderItemRow(item: item) {
                                        if let index = cart.firstIndex(where: { $0.id == item.id }) {
                                            cart.remove(at: index)
                                        }
                                    }
                                }
                                
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Subtotal")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", subtotal))")
                                            .foregroundColor(.white)
                                    }
                                    
                                    HStack {
                                        Text("Tax")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", tax))")
                                            .foregroundColor(.white)
                                    }
                                    
                                    if orderType == .delivery {
                                        HStack {
                                            Text("Delivery Fee")
                                                .foregroundColor(.white)
                                            Spacer()
                                            Text("$\(String(format: "%.2f", deliveryFee))")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.3))
                                        .padding(.vertical, 4)
                                    
                                    HStack {
                                        Text("Total")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("$\(String(format: "%.2f", total))")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding()
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
                        
                        // Payment Button
                        Button(action: onPayment) {
                            HStack {
                                Image(systemName: "applelogo")
                                Text("Pay with Apple Pay")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isFormValid ? Color.white.opacity(0.2) : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
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
                            .shadow(color: Color.black.opacity(isFormValid ? 0.15 : 0.05), radius: 6, x: 0, y: 3)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal)
                    }
                    .padding()
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onDismiss)
                        .foregroundColor(.white)
                }
            }
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(item.quantity)x")
                    .foregroundColor(.white.opacity(0.7))
                Text(item.menuItem.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("$\(String(format: "%.2f", item.menuItem.price * Double(item.quantity)))")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
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
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text("+$\(String(format: "%.2f", option.price))")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }
            }
            
            if !item.specialInstructions.isEmpty {
                Text("Note: \(item.specialInstructions)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
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
    
    // Enhanced blue gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "1a73e8"), // Vibrant blue
                Color(hex: "0d47a1"), // Deep blue
                Color(hex: "002171"), // Dark blue
                Color(hex: "002984")  // Navy blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                backgroundGradient
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
                
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Text("Total Amount")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("$\(String(format: "%.2f", amount))")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    VStack(spacing: 16) {
                        Button {
                            onSuccess()
                        } label: {
                            HStack {
                                Image(systemName: "applelogo")
                                Text("Pay with Apple Pay")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
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
                        }
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Button {
                            onSuccess()
                        } label: {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                Text("Pay with Credit Card")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.white.opacity(0.2))
                            .foregroundColor(.white)
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
                        }
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
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
                    .padding()
                }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onDismiss)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
