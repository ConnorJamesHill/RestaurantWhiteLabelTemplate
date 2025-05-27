//
//  OwnerAnalyticsView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import SwiftUI
import Charts

struct OwnerAnalyticsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    var viewModel: OwnerDashboardViewViewModel
    
    var body: some View {
        ZStack {
            // Background gradient from ThemeManager
            themeManager.backgroundGradient
                .ignoresSafeArea()
            
            // Decorative elements
            Circle()
                .fill(Color.white.opacity(0.05))
                .frame(width: 300, height: 300)
                .blur(radius: 30)
                .offset(x: -150, y: -100)
            
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 250, height: 250)
                .blur(radius: 20)
                .offset(x: 180, y: 400)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Quick Stats Section
                    quickStatsSection
                    
                    // Revenue Chart
                    revenueChartSection
                    
                    // Popular Items Section
                    popularItemsSection
                    
                    // Recent Orders
                    recentOrdersSection
                }
                .padding()
            }
        }
    }
    
    // MARK: - Quick Stats Section
    var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            HStack(spacing: 12) {
                // Today's Revenue
                GlassStatCard(
                    title: "Today's Revenue",
                    value: "$\(String(format: "%.2f", viewModel.todayRevenue))",
                    trend: viewModel.revenueTrend,
                    iconName: "dollarsign.circle.fill"
                )
                
                // Today's Orders
                GlassStatCard(
                    title: "Today's Orders",
                    value: "\(viewModel.todayOrders)",
                    trend: viewModel.ordersTrend,
                    iconName: "bag.fill"
                )
            }
            
            HStack(spacing: 12) {
                // Average Order Value
                GlassStatCard(
                    title: "Avg Order Value",
                    value: "$\(String(format: "%.2f", viewModel.averageOrderValue))",
                    trend: viewModel.avgOrderTrend,
                    iconName: "creditcard.fill"
                )
                
                // Table Usage
                GlassStatCard(
                    title: "Table Usage",
                    value: "\(viewModel.activeTables)/\(viewModel.totalTables)",
                    trend: nil,
                    iconName: "table.furniture.fill"
                )
            }
        }
    }
    
    // MARK: - Revenue Chart Section
    var revenueChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Revenue Trends")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            GlassCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Last 7 Days")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textColor)
                    
                    // The chart
                    Chart {
                        ForEach(viewModel.revenueData) { data in
                            BarMark(
                                x: .value("Day", data.date, unit: .day),
                                y: .value("Revenue", data.amount)
                            )
                            .foregroundStyle(themeManager.primaryColor.gradient)
                            .cornerRadius(8)
                        }
                    }
                    .frame(height: 180)
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let value = value.as(Double.self) {
                                    Text("$\(String(format: "%.0f", value))")
                                        .font(.caption2)
                                        .foregroundColor(themeManager.textColor.opacity(0.7))
                                }
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(date, format: .dateTime.weekday(.short))
                                        .font(.caption2)
                                        .foregroundColor(themeManager.textColor.opacity(0.7))
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Popular Items Section
    var popularItemsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Items")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            GlassCard {
                VStack(spacing: 4) {
                    ForEach(viewModel.popularItems) { item in
                        HStack(spacing: 16) {
                            Text("\(item.id)")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.textColor.opacity(0.6))
                                .frame(width: 30, height: 30)
                                .background(
                                    item.id <= 3 ?
                                    Circle().fill(themeManager.primaryColor.opacity(0.2)) :
                                    Circle().fill(themeManager.textColor.opacity(0.1))
                                )
                            
                            Text(item.name)
                                .font(.callout)
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                            
                            Text("\(item.orderCount) orders")
                                .font(.subheadline)
                                .foregroundColor(themeManager.textColor.opacity(0.7))
                        }
                        .padding(.vertical, 8)
                        
                        if item.id != viewModel.popularItems.last?.id {
                            Divider()
                                .background(themeManager.textColor.opacity(0.2))
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Recent Orders Section
    var recentOrdersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Orders")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            GlassCard {
                VStack(spacing: 4) {
                    ForEach(viewModel.recentOrders) { order in
                        HStack(spacing: 16) {
                            Circle()
                                .fill(order.status.color)
                                .frame(width: 10, height: 10)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Order #\(order.number)")
                                    .font(.callout)
                                    .foregroundColor(themeManager.textColor)
                                
                                Text(order.status.rawValue)
                                    .font(.caption)
                                    .foregroundColor(order.status.color)
                            }
                            
                            Spacer()
                            
                            Text("$\(String(format: "%.2f", order.total))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(themeManager.textColor)
                        }
                        .padding(.vertical, 8)
                        
                        if order.id != viewModel.recentOrders.last?.id {
                            Divider()
                                .background(themeManager.textColor.opacity(0.2))
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Reusable Glass Card Component
    struct GlassCard<Content: View>: View {
        @EnvironmentObject private var themeManager: ThemeManager
        @ViewBuilder let content: Content
        
        var body: some View {
            content
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .black.opacity(0.5),
                                    .clear,
                                    .black.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
        }
    }
    
    // MARK: - Stat Card with Glassmorphism
    struct GlassStatCard: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let value: String
        let trend: Double?
        let iconName: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: iconName)
                        .font(.title3)
                        .foregroundColor(themeManager.primaryColor)
                    
                    Spacer()
                    
                    if let trend = trend {
                        HStack(spacing: 2) {
                            Image(systemName: trend >= 0 ? "arrow.up" : "arrow.down")
                                .font(.caption2)
                                .foregroundColor(trend >= 0 ? .green : .red)
                            
                            Text("\(String(format: "%.1f", abs(trend)))%")
                                .font(.caption2)
                                .foregroundColor(trend >= 0 ? .green : .red)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.white.opacity(0.81034))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.black.opacity(0.3), lineWidth: 0.15)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.textColor)
                    
                    Text(title)
                        .font(.caption)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .black.opacity(0.5),
                                .clear,
                                .black.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
        }
    }
}
