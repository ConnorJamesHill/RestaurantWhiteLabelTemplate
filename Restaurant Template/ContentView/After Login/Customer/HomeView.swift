import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    
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
                .padding(.bottom, 16)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(restaurant.name)
                            .font(.headline)
                        Text(restaurant.tagline)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
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
                .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 120)
        }
        .ignoresSafeArea(edges: .top)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
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
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Featured Items")
            
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
                .padding(.bottom, 4)
            }
        }
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Upcoming Events")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(events) { event in
                        EventCard(event: event)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 4)
            }
        }
    }
    
    private var welcomeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "About Us")
            
            Text(restaurant.welcomeMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            
            NavigationLink(destination: InfoView()) {
                Text("Learn More")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.primary)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            }
            .padding(.leading)
        }
    }
    
    private var todayHoursSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle(title: "Today's Hours")
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.primary)
                
                Text("Open today: \(restaurant.todayHours)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                NavigationLink(destination: InfoView()) {
                    Text("Full Hours")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }
}

// MARK: - Supporting Views

struct SectionTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
}

struct ActionButton: View {
    let title: String
    let iconName: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
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
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
            
            // Title and description
            Text(item.name)
                .font(.headline)
                .lineLimit(1)
            
            Text(item.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(height: 36)
            
            // Price
            Text("$\(String(format: "%.2f", item.price))")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(width: 200)
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
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
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                
                // Date bubble
                Text(dateFormatter.string(from: event.date))
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.primary)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .padding(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            
            // Title and description
            Text(event.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(event.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .frame(height: 36)
        }
        .frame(width: 260)
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
    }
}
