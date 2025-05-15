//
//  OwnerAnalyticsView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import SwiftUI

struct OwnerAnalyticsView: View {
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    @Environment(\.colorScheme) private var colorScheme
    var onMenuButtonTap: (() -> Void)? // Add callback for menu button
    
    // Enhanced blue gradient background
    var backgroundGradient: LinearGradient {
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
                
                // Decorative elements - using black instead of white
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
                        // Title with glass effect
                        Text("Analytics Dashboard")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 6)
                            .padding(.top, 10)
                        
                        // Quick Stats Cards
                        quickStatsSection
                        
                        // Revenue Chart
                        revenueChartSection
                        
                        // Popular Items
                        popularItemsSection
                        
                        // Recent Orders
                        recentOrdersSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Analytics")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    var quickStatsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            GlassStatCard(
                title: "Today's Revenue",
                value: String(format: "$%.2f", viewModel.todayRevenue),
                trend: viewModel.revenueTrend,
                icon: "dollarsign.circle.fill",
                tint: .blue
            )
            
            GlassStatCard(
                title: "Orders Today",
                value: String(viewModel.todayOrders),
                trend: viewModel.ordersTrend,
                icon: "bag.fill",
                tint: .green
            )
            
            GlassStatCard(
                title: "Avg Order Value",
                value: String(format: "$%.2f", viewModel.averageOrderValue),
                trend: viewModel.avgOrderTrend,
                icon: "chart.bar.fill",
                tint: .orange
            )
            
            GlassStatCard(
                title: "Active Tables",
                value: "\(viewModel.activeTables)/\(viewModel.totalTables)",
                trend: nil,
                icon: "tablecells.fill",
                tint: .purple
            )
        }
    }
    
    var revenueChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Overview")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            
            // Simple alternative without Charts if needed
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(viewModel.revenueData.prefix(7).enumerated()), id: \.element.id) { index, data in
                    HStack {
                        Text(data.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("$\(data.amount, specifier: "%.2f")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    if index < viewModel.revenueData.prefix(7).count - 1 {
                        Divider()
                            .background(Color.black.opacity(0.3))
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(8)
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
    
    var popularItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Items")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            
            ForEach(Array(viewModel.popularItems.enumerated()), id: \.element.id) { index, item in
                HStack {
                    Text(item.name)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(item.orderCount) orders")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if index < viewModel.popularItems.count - 1 {
                    Divider()
                        .background(Color.black.opacity(0.3))
                        .padding(.horizontal)
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
    }
    
    var recentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Orders")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            
            ForEach(viewModel.recentOrders) { order in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Order #\(order.number)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", order.total))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    StatusPill(status: order.status)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [.black.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 2)
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
    }
}

// MARK: - Supporting Views

// Glass card for stats
struct GlassStatCard: View {
    let title: String
    let value: String
    let trend: Double?
    let icon: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .padding(8)
                    .background(tint.opacity(0.3))
                    .clipShape(Circle())
                
                Spacer()
                
                if let trend = trend {
                    HStack(spacing: 4) {
                        Image(systemName: trend >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(abs(trend), specifier: "%.1f")%")
                    }
                    .font(.caption2)
                    .foregroundColor(trend >= 0 ? .green : .red)
                    .padding(4)
                    .background(
                        (trend >= 0 ? Color.green : Color.red)
                            .opacity(0.2)
                            .clipShape(Capsule())
                    )
                }
            }
            
            Spacer()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .frame(height: 140)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.black.opacity(0.7), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// Status pill with enhanced visibility on blue background
struct StatusPill: View {
    let status: Order.OrderStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(statusColor)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
    
    private var statusColor: Color {
        switch status {
        case .pending: return Color.orange.opacity(0.5)
        case .inProgress: return Color.blue.opacity(0.5)
        case .completed: return Color.green.opacity(0.5)
        }
    }
}
