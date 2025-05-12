import SwiftUI
import Charts

struct OwnerDashboardView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    
    var body: some View {
        TabView {
            // Dashboard Tab - Analytics
            OwnerAnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
            
            // Menu Management Tab
            OwnerMenuView()
                .tabItem {
                    Label("Menu", systemImage: "doc.text.fill")
                }
            
            // Orders Management Tab
            OwnerOrdersView()
                .tabItem {
                    Label("Orders", systemImage: "bag.fill")
                }
            
            // Reservations Management Tab
            OwnerReservationsView()
                .tabItem {
                    Label("Tables", systemImage: "calendar")
                }
            
            // Marketing & Promotions Tab
            OwnerMarketingView()
                .tabItem {
                    Label("Marketing", systemImage: "megaphone.fill")
                }
            
            // Settings & Account Tab
            OwnerSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .navigationTitle("Restaurant Manager")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.signOut()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
            }
        }
    }
}



// MARK: - Supporting Views

// StatCard view definition
struct StatCard: View {
    let title: String
    let value: String
    let trend: Double?
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let trend = trend {
                    HStack(spacing: 4) {
                        Image(systemName: trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(abs(trend), specifier: "%.1f")%")
                    }
                    .font(.caption2)
                    .foregroundColor(trend >= 0 ? .green : .red)
                }
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
