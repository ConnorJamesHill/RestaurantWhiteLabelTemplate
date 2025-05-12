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
            .navigationTitle("Order Online")
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
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
    
    private var menuContent: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(restaurant.menuCategories) { category in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(category.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        ForEach(category.items) { item in
                            MenuItemRow(item: item) {
                                selectedItem = item
                            }
                        }
                    }
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
            
            HStack {
                VStack(alignment: .leading) {
                    Text("\(totalItems) \(totalItems == 1 ? "item" : "items")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("$\(String(format: "%.2f", cartTotal))")
                        .font(.headline)
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
                        .background(Color.primary)
                        .cornerRadius(8)
                }
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            .padding()
            .background(Color(.systemBackground))
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
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
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
                    
                    Text(plan.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", plan.price))")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(plan.frequency)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(plan.benefits, id: \.self) { benefit in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(benefit)
                            .font(.subheadline)
                    }
                }
            }
            
            Button(action: onSubscribe) {
                Text("Subscribe Now")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .cornerRadius(10)
            }
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct OrderItemDetailView: View {
    let item: MenuItem
    let onAdd: (OrderItem) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var specialInstructions = ""
    @State private var selectedCustomizations: [Customization] = []
    
    var body: some View {
        NavigationStack {
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
                        
                        Text(item.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", item.price))")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                    
                    // Quantity selector
                    HStack {
                        Text("Quantity")
                            .font(.headline)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                            }
                            
                            Text("\(quantity)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(minWidth: 30)
                            
                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    
                    // Special instructions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Special Instructions")
                            .font(.headline)
                        
                        TextField("Add note (optional)", text: $specialInstructions, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
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
                    .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
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
            Form {
                Section("Contact Information") {
                    VStack(spacing: 12) {
                        TextField("Name", text: $customerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        TextField("Phone", text: $customerPhone)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        TextField("Email", text: $customerEmail)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                
                Section("Order Type") {
                    VStack(spacing: 16) {
                        Picker("Delivery Method", selection: $orderType) {
                            Text("Pickup").tag(OrderType.pickup)
                            Text("Delivery").tag(OrderType.delivery)
                        }
                        .pickerStyle(.segmented)
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        if orderType == .delivery {
                            VStack(spacing: 12) {
                                TextField("Delivery Address", text: $deliveryAddress, axis: .vertical)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .lineLimit(3...6)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                
                                TextField("Delivery Instructions (Optional)", text: $deliveryInstructions, axis: .vertical)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .lineLimit(2...4)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                        } else {
                            DatePicker(
                                "Pickup Time",
                                selection: $selectedPickupTime,
                                in: Date()...,
                                displayedComponents: [.hourAndMinute]
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                
                Section("Order Summary (\(totalItems) \(totalItems == 1 ? "item" : "items"))") {
                    VStack(spacing: 16) {
                        ForEach(cart) { item in
                            OrderItemRow(item: item) {
                                if let index = cart.firstIndex(where: { $0.id == item.id }) {
                                    cart.remove(at: index)
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                        }
                        
                        VStack(spacing: 12) {
                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text("$\(String(format: "%.2f", subtotal))")
                            }
                            
                            HStack {
                                Text("Tax")
                                Spacer()
                                Text("$\(String(format: "%.2f", tax))")
                            }
                            
                            if orderType == .delivery {
                                HStack {
                                    Text("Delivery Fee")
                                    Spacer()
                                    Text("$\(String(format: "%.2f", deliveryFee))")
                                }
                            }
                            
                            Divider()
                                .padding(.vertical, 4)
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                Text("$\(String(format: "%.2f", total))")
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                    }
                    .padding(.vertical, 8)
                }
                .listRowBackground(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                
                Section {
                    Button(action: onPayment) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Pay with Apple Pay")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(isFormValid ? Color.primary : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(isFormValid ? 0.15 : 0.05), radius: 6, x: 0, y: 3)
                    }
                    .disabled(!isFormValid)
                }
                .listRowBackground(Color.clear)
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onDismiss)
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
                    .foregroundColor(.secondary)
                Text(item.menuItem.name)
                    .font(.headline)
                Spacer()
                Text("$\(String(format: "%.2f", item.menuItem.price * Double(item.quantity)))")
                    .fontWeight(.semibold)
                
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
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("+$\(String(format: "%.2f", option.price))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            if !item.specialInstructions.isEmpty {
                Text("Note: \(item.specialInstructions)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct PaymentView: View {
    let amount: Double
    let onDismiss: () -> Void
    let onSuccess: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Payment Sheet")
                    .onTapGesture {
                        onSuccess()
                    }
            }
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onDismiss)
                }
            }
        }
    }
}
