import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    
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
    
    let featuredItems = [
        FeaturedItem(
            id: UUID(),
            name: "Chef's Special",
            description: "Truffle Butter Filet Mignon with roasted vegetables",
            price: 34.99,
            imageName: "featured_1"
        ),
        FeaturedItem(
            id: UUID(),
            name: "Signature Pasta",
            description: "Handmade tagliatelle with wild mushroom ragout",
            price: 24.99,
            imageName: "featured_2"
        ),
        FeaturedItem(
            id: UUID(),
            name: "Dessert of the Day",
            description: "Vanilla bean crème brûlée with seasonal berries",
            price: 10.99,
            imageName: "featured_3"
        )
    ]
    
    let events = [
        Event(
            id: UUID(),
            title: "Wine Tasting",
            description: "Join us for a special evening featuring wines from Napa Valley",
            date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            imageName: "event_1"
        ),
        Event(
            id: UUID(),
            title: "Live Jazz Night",
            description: "Enjoy live jazz music while dining with us every Friday",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            imageName: "event_2"
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
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Hero image and restaurant info
                        heroSection
                        
                        // Quick action buttons
                        actionButtonsSection
                        
                        // Featured items
                        featuredItemsSection
                        
                        // Events
                        eventsSection
                        
                        // Welcome message
                        welcomeSection
                        
                        // Today's hours
                        todayHoursSection
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(restaurant.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(restaurant.tagline)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
    
    // MARK: - UI Sections
    
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            // Hero image
            Image("restaurant_logo")
                .resizable()
                .scaledToFill()
                .frame(height: 280)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal)
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: 12) {
            ActionButton(title: "Menu", iconName: "menucard", destination: AnyView(MenuView()))
            ActionButton(title: "Order", iconName: "bag", destination: AnyView(OrderView()))
            ActionButton(title: "Reserve", iconName: "calendar", destination: AnyView(ReservationView()))
        }
        .padding(.horizontal)
    }
    
    private var featuredItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Items")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(featuredItems) { item in
                        NavigationLink(destination: MenuView()) {
                            FeaturedItemCard(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Events")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(events) { event in
                        EventCard(event: event)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About Us")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Text(restaurant.welcomeMessage)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
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
            
            NavigationLink(destination: InfoView()) {
                Text("Learn More")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.primary)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(.leading)
        }
    }
    
    private var todayHoursSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Hours")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.white)
                
                Text("Open today: \(restaurant.todayHours)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                NavigationLink(destination: InfoView()) {
                    Text("Full Hours")
                        .font(.subheadline)
                        .foregroundColor(.white)
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
        }
    }
}

// MARK: - Supporting Views

struct ActionButton: View {
    let title: String
    let iconName: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.callout)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
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
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}

struct FeaturedItemCard: View {
    let item: FeaturedItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 140)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.15)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
            
            // Title and description
            Text(item.name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(item.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
                .frame(height: 36)
            
            // Price
            Text("$\(String(format: "%.2f", item.price))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .frame(width: 200)
        .padding(12)
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
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct EventCard: View {
    let event: Event
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image with date overlay
            ZStack(alignment: .topLeading) {
                Image(event.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 260, height: 150)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 0.15)
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
                
                // Date bubble
                Text(dateFormatter.string(from: event.date))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                    )
                    .padding(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            
            // Title and description
            Text(event.title)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(event.description)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(2)
                .frame(height: 36)
        }
        .frame(width: 260)
        .padding(12)
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
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}
