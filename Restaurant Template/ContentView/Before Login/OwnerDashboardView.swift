//
//  OwnerDashboardView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/7/25.
//

import SwiftUI
import Charts

struct OwnerDashboardView: View {
    @EnvironmentObject private var restaurant: RestaurantConfiguration
    @StateObject private var viewModel = OwnerDashboardViewViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Quick Stats Cards
                    quickStatsSection
                    
                    // Revenue Chart
                    revenueChartSection
                    
                    // Popular Items
                    popularItemsSection
                    
                    // Recent Orders
                    recentOrdersSection
                    
                    // Staff Management
                    staffManagementSection
                }
                .padding()
            }
            .navigationTitle("Dashboard")
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
    
    // MARK: - Dashboard Sections
    
    private var quickStatsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Today's Revenue",
                value: String(format: "$%.2f", viewModel.todayRevenue),
                trend: viewModel.revenueTrend,
                icon: "dollarsign.circle.fill"
            )
            
            StatCard(
                title: "Orders Today",
                value: String(viewModel.todayOrders),
                trend: viewModel.ordersTrend,
                icon: "bag.fill"
            )
            
            StatCard(
                title: "Avg Order Value",
                value: String(format: "$%.2f", viewModel.averageOrderValue),
                trend: viewModel.avgOrderTrend,
                icon: "chart.bar.fill"
            )
            
            StatCard(
                title: "Active Tables",
                value: "\(viewModel.activeTables)/\(viewModel.totalTables)",
                trend: nil,
                icon: "tablecells.fill"
            )
        }
    }
    
    private var revenueChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Overview")
                .font(.headline)
            
            Chart(viewModel.revenueData) { data in
                LineMark(
                    x: .value("Day", data.date),
                    y: .value("Revenue", data.amount)
                )
                .foregroundStyle(Color.primary)
                
                AreaMark(
                    x: .value("Day", data.date),
                    y: .value("Revenue", data.amount)
                )
                .foregroundStyle(Color.primary.opacity(0.1))
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var popularItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Items")
                .font(.headline)
            
            ForEach(viewModel.popularItems) { item in
                HStack {
                    Text(item.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(item.orderCount) orders")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                if item.id != viewModel.popularItems.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var recentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Orders")
                .font(.headline)
            
            ForEach(viewModel.recentOrders) { order in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Order #\(order.number)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text(String(format: "$%.2f", order.total))
                            .font(.subheadline)
                    }
                    
                    Text(order.status.rawValue)
                        .font(.caption)
                        .foregroundColor(order.status.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.1))
                        .cornerRadius(4)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var staffManagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Staff Management")
                .font(.headline)
            
            ForEach(viewModel.activeStaff) { staff in
                HStack {
                    Circle()
                        .fill(staff.isActive ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    
                    Text(staff.name)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text(staff.role)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                if staff.id != viewModel.activeStaff.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Supporting Views

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

