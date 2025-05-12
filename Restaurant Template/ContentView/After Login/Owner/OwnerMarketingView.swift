//
//  OwnerMarketingView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import Foundation
import SwiftUI

struct OwnerMarketingView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // Blue gradient background - matching other owner views
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
            .navigationTitle("Marketing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Create new promotion
                    } label: {
                        Text("New")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.regularMaterial)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    private var marketingOverviewSection: some View {
        HStack(spacing: 15) {
            marketingStatView(count: "3", title: "Active Promotions", iconName: "tag.fill", color: .blue)
            marketingStatView(count: "235", title: "Customer Engagements", iconName: "person.3.fill", color: .green)
            marketingStatView(count: "18%", title: "Response Rate", iconName: "chart.line.uptrend.xyaxis", color: .orange)
        }
    }
    
    private func marketingStatView(count: String, title: String, iconName: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding(8)
                .background(color.opacity(0.3))
                .clipShape(Circle())
            
            Text(count)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.6), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        )
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private var activePromotionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Active Promotions")
            
            // Happy Hour
            promotionCard(
                title: "Happy Hour Special",
                description: "50% off appetizers Monday-Friday",
                dates: "Active until Jun 30",
                status: "Active",
                iconName: "wineglass",
                color: .purple
            )
            
            // Weekend Brunch
            promotionCard(
                title: "Weekend Brunch",
                description: "Complimentary mimosa with any brunch entrée",
                dates: "Weekends 9am-1pm",
                status: "Active",
                iconName: "sun.max.fill",
                color: .orange
            )
            
            // Loyalty Bonus
            promotionCard(
                title: "Loyalty Bonus Month",
                description: "Double points on all purchases",
                dates: "All month long",
                status: "Active",
                iconName: "star.fill",
                color: .yellow
            )
            
            Button {
                // Create new promotion
            } label: {
                HStack {
                    Spacer()
                    Label("Add New Promotion", systemImage: "plus.circle")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                )
                .shadow(color: Color.white.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var customerEngagementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Customer Engagement")
            
            // Loyalty Program
            engagementItemView(
                title: "Loyalty Program",
                description: "1,253 members enrolled",
                iconName: "star.circle.fill",
                color: .yellow
            )
            
            // Push Notifications
            engagementItemView(
                title: "Push Notifications",
                description: "Send updates to customer devices",
                iconName: "bell.fill",
                color: .blue
            )
            
            // Email Campaign
            engagementItemView(
                title: "Email Campaign",
                description: "2,485 subscribers",
                iconName: "envelope.fill",
                color: .green
            )
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var analyticsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Analytics")
            
            // Promotion Impact
            analyticsItemView(
                title: "Promotion Impact",
                description: "Measure ROI of marketing efforts",
                iconName: "chart.line.uptrend.xyaxis",
                color: .purple,
                value: "+32%",
                valueLabel: "Revenue increase"
            )
            
            // Customer Retention
            analyticsItemView(
                title: "Customer Retention",
                description: "Track repeat customers and loyalty",
                iconName: "person.2.fill",
                color: .blue,
                value: "76%",
                valueLabel: "Return rate"
            )
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .padding(.bottom, 8)
    }
    
    private func promotionCard(title: String, description: String, dates: String, status: String, iconName: String, color: Color) -> some View {
        NavigationLink(destination: Text("Edit Promotion")) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(color.opacity(0.3))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack {
                        Text(dates)
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Spacer()
                        
                        Text(status)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.green.opacity(0.3))
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.green.opacity(0.5), lineWidth: 0.5)
                            )
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func engagementItemView(title: String, description: String, iconName: String, color: Color) -> some View {
        NavigationLink(destination: Text(title)) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(8)
                    .background(color.opacity(0.3))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func analyticsItemView(title: String, description: String, iconName: String, color: Color, value: String, valueLabel: String) -> some View {
        NavigationLink(destination: Text(title)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: iconName)
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(8)
                            .background(color.opacity(0.3))
                            .clipShape(Circle())
                        
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(valueLabel)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
