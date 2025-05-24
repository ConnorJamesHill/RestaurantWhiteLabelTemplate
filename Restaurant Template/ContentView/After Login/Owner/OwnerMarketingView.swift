//
//  OwnerMarketingView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import Foundation
import SwiftUI
import Charts

struct OwnerMarketingView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Sample data for promotions
    let promotions = [
        PromotionData(
            id: "P1001",
            title: "Happy Hour Special",
            description: "Half price on selected appetizers and drinks",
            startDate: "June 1, 2023",
            endDate: "August 31, 2023",
            type: .happyHour,
            isActive: true
        ),
        PromotionData(
            id: "P1002",
            title: "Weekend Brunch",
            description: "Complimentary mimosa with any brunch entree",
            startDate: "May 15, 2023",
            endDate: "December 31, 2023",
            type: .event,
            isActive: true
        ),
        PromotionData(
            id: "P1003",
            title: "Summer Menu Launch",
            description: "New seasonal items with 15% off for the first week",
            startDate: "June 15, 2023",
            endDate: "June 22, 2023",
            type: .seasonal,
            isActive: false
        ),
        PromotionData(
            id: "P1004",
            title: "Loyalty Program",
            description: "Earn points with every purchase for exclusive rewards",
            startDate: "January 1, 2023",
            endDate: "December 31, 2023",
            type: .loyalty,
            isActive: true
        )
    ]
    
    // Sample data for engagement metrics
    let engagementData = [
        EngagementData(month: "Jan", value: 120),
        EngagementData(month: "Feb", value: 150),
        EngagementData(month: "Mar", value: 180),
        EngagementData(month: "Apr", value: 220),
        EngagementData(month: "May", value: 270),
        EngagementData(month: "Jun", value: 250)
    ]
    
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
                        // Marketing Overview
                        marketingOverviewSection
                        
                        // Active Promotions
                        activePromotionsSection
                        
                        // Customer Engagement
                        customerEngagementSection
                        
                        // Analytics
                        analyticsSection
                    }
                    .padding()
                }
            }
    }
    
    // MARK: - Marketing Overview Section
    var marketingOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Marketing Overview")
                        .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            HStack(spacing: 12) {
                // Active Promotions Card
                MetricCard(
                    title: "Active Promotions",
                    value: "\(promotions.filter { $0.isActive }.count)",
                    icon: "megaphone.fill",
                    trend: "+2",
                    trendUp: true
                )
                
                // Customer Engagement Card
                MetricCard(
                    title: "Engagement",
                    value: "485",
                    icon: "person.3.fill",
                    trend: "+14%",
                    trendUp: true
                )
            }
            
            HStack(spacing: 12) {
                // Social Media Reach Card
                MetricCard(
                    title: "Social Reach",
                    value: "2.4K",
                    icon: "heart.fill",
                    trend: "+5%",
                    trendUp: true
                )
                
                // Email Campaign Card
                MetricCard(
                    title: "Open Rate",
                    value: "28%",
                    icon: "envelope.fill",
                    trend: "-2%",
                    trendUp: false
                )
            }
        }
    }
    
    // MARK: - Active Promotions Section
    var activePromotionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Promotions")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            VStack(spacing: 12) {
                ForEach(promotions) { promotion in
                    PromotionCard(promotion: promotion)
                }
                
                // Create Promotion Button
                Button {
                    // Create new promotion action
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.primaryColor)
                        
                        Text("Create New Promotion")
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                    }
                    .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                                    colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
            }
        }
    }
    
    // MARK: - Customer Engagement Section
    var customerEngagementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customer Engagement")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            // Engagement Chart
            GlassCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Monthly Engagement")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textColor)
                    
                    Chart {
                        ForEach(engagementData) { data in
                            BarMark(
                                x: .value("Month", data.month),
                                y: .value("Engagement", data.value)
                            )
                            .foregroundStyle(themeManager.primaryColor.gradient)
                            .cornerRadius(6)
                        }
                    }
                    .frame(height: 180)
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let value = value.as(Double.self) {
                                    Text("\(Int(value))")
                                        .font(.caption2)
                                        .foregroundColor(themeManager.textColor.opacity(0.7))
                                }
                            }
                        }
                    }
                    .chartXAxis {
                        AxisMarks { value in
                            AxisValueLabel {
                                if let month = value.as(String.self) {
                                    Text(month)
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
    
    // MARK: - Analytics Section
    var analyticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Marketing Analytics")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            VStack(spacing: 12) {
                // Channel Performance
                AnalyticsCard(
                    title: "Channel Performance",
                    metrics: [
                        ChannelMetric(channel: "Social Media", value: 42, color: .blue),
                        ChannelMetric(channel: "Email", value: 28, color: .green),
                        ChannelMetric(channel: "Website", value: 18, color: .orange),
                        ChannelMetric(channel: "In-Store", value: 12, color: .purple)
                    ]
                )
                
                // Audience Demographics
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Audience Demographics")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                        
                        HStack(spacing: 20) {
                            // Age Groups
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Age Groups")
                                    .font(.caption)
                                    .foregroundColor(themeManager.textColor.opacity(0.7))
                                
                                HStack {
                                    Text("25-34")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Text("38%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                }
                                
                                ProgressBar(value: 0.38, color: themeManager.primaryColor)
                                
                                HStack {
                                    Text("35-44")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Text("32%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                }
                                
                                ProgressBar(value: 0.32, color: themeManager.secondaryColor)
                                
                                HStack {
                                    Text("18-24")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Text("18%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                }
                                
                                ProgressBar(value: 0.18, color: Color.orange)
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Gender
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Gender")
                                    .font(.caption)
                                    .foregroundColor(themeManager.textColor.opacity(0.7))
                                
                                HStack {
                                    Text("Female")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Text("54%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                }
                                
                                ProgressBar(value: 0.54, color: Color.purple)
                                
                                HStack {
                                    Text("Male")
                                        .font(.caption)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Text("46%")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(themeManager.textColor)
                                }
                                
                                ProgressBar(value: 0.46, color: Color.blue)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Helper Components
    
    struct GlassCard<Content: View>: View {
        @EnvironmentObject private var themeManager: ThemeManager
        @ViewBuilder let content: Content
        
        var body: some View {
            content
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                                colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.15
                )
        )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    struct MetricCard: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let value: String
        let icon: String
        let trend: String
        let trendUp: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(themeManager.primaryColor)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: trendUp ? "arrow.up" : "arrow.down")
                            .font(.caption2)
                            .foregroundColor(trendUp ? .green : .red)
                        
                        Text(trend)
                            .font(.caption2)
                            .foregroundColor(trendUp ? .green : .red)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.white.opacity(0.6))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.3), lineWidth: 0.15)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.textColor)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    struct PromotionCard: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let promotion: PromotionData
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                // Header with type badge and active status
                HStack {
                    PromotionTypeBadge(type: promotion.type)
                    
                    Spacer()
                    
                    // Active status toggle
                    HStack(spacing: 6) {
                        Circle()
                            .fill(promotion.isActive ? .green : .gray)
                            .frame(width: 8, height: 8)
                        
                        Text(promotion.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundColor(promotion.isActive ? .green : .gray)
                    }
                }
                
                // Title and description
                Text(promotion.title)
                        .font(.headline)
                    .foregroundColor(themeManager.textColor)
                
                Text(promotion.description)
                    .font(.subheadline)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
                    .lineLimit(2)
                
                // Date range
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(themeManager.primaryColor)
                    
                    Text("\(promotion.startDate) to \(promotion.endDate)")
                        .font(.caption)
                        .foregroundColor(themeManager.textColor.opacity(0.7))
                }
                
                // Actions
                HStack {
                    Button {
                        // Edit action
                    } label: {
                        Text("Edit")
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeManager.textColor.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                    
                    Button {
                        // Duplicate action
                    } label: {
                        Text("Duplicate")
                        .font(.subheadline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themeManager.textColor.opacity(0.2), lineWidth: 0.5)
                            )
                }
                
                Spacer()
                
                    // Toggle button (for active/inactive)
                    if promotion.isActive {
                        Button {
                            // Pause action
                        } label: {
                            Text("Pause")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.orange)
                                .cornerRadius(8)
                                .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                    } else {
                        Button {
                            // Activate action
                        } label: {
                            Text("Activate")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.green)
                                .cornerRadius(8)
                                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 2)
                        }
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
                            colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    struct PromotionTypeBadge: View {
        let type: PromotionType
        
        var body: some View {
            HStack(spacing: 4) {
                Image(systemName: type.icon)
                    .font(.caption2)
                    .foregroundColor(type.color)
                
                Text(type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(type.color)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(type.color.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    struct AnalyticsCard: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let metrics: [ChannelMetric]
        
        var body: some View {
            GlassCard {
                VStack(alignment: .leading, spacing: 16) {
                        Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                    
                    // Horizontal stacked bar
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            ForEach(metrics) { metric in
                                Rectangle()
                                    .fill(metric.color)
                                    .frame(width: CGFloat(metric.value) / 100 * geometry.size.width)
                            }
                        }
                        .cornerRadius(8)
                        .frame(height: 24)
                    }
                    .frame(height: 24)
                    
                    // Legend
                    VStack(spacing: 8) {
                        ForEach(metrics) { metric in
                            HStack {
                                Circle()
                                    .fill(metric.color)
                                    .frame(width: 10, height: 10)
                                
                                Text(metric.channel)
                                    .font(.caption)
                                    .foregroundColor(themeManager.textColor)
                
                Spacer()
                
                                Text("\(metric.value)%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(themeManager.textColor)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    struct ProgressBar: View {
        let value: Double
        let color: Color
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width))
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Supporting Types

struct PromotionData: Identifiable {
    let id: String
    let title: String
    let description: String
    let startDate: String
    let endDate: String
    let type: PromotionType
    let isActive: Bool
}

enum PromotionType: String {
    case discount = "Discount"
    case event = "Event"
    case seasonal = "Seasonal"
    case loyalty = "Loyalty"
    case happyHour = "Happy Hour"
    
    var icon: String {
        switch self {
        case .discount: return "percent"
        case .event: return "calendar"
        case .seasonal: return "leaf"
        case .loyalty: return "heart"
        case .happyHour: return "wineglass"
        }
    }
    
    var color: Color {
        switch self {
        case .discount: return .blue
        case .event: return .purple
        case .seasonal: return .green
        case .loyalty: return .pink
        case .happyHour: return .orange
        }
    }
}

struct EngagementData: Identifiable {
    let id = UUID()
    let month: String
    let value: Double
}

struct ChannelMetric: Identifiable {
    let id = UUID()
    let channel: String
    let value: Int
    let color: Color
}
