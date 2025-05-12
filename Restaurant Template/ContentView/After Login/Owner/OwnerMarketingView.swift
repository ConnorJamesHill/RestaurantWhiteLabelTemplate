//
//  OwnerMarketingView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import Foundation
import SwiftUI

struct OwnerMarketingView: View {
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Marketing")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Create new promotion
                    } label: {
                        Text("New")
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
    
    // MARK: - Sections
    
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
                .foregroundColor(color)
                .font(.system(size: 20))
            
            Text(count)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                    Spacer()
                }
                .background(Color.primary.opacity(0.05))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
    
    // MARK: - Helper Views
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.bottom, 8)
    }
    
    private func promotionCard(title: String, description: String, dates: String, status: String, iconName: String, color: Color) -> some View {
        NavigationLink(destination: Text("Edit Promotion")) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
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
                            .background(Color.green)
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func engagementItemView(title: String, description: String, iconName: String, color: Color) -> some View {
        NavigationLink(destination: Text(title)) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func analyticsItemView(title: String, description: String, iconName: String, color: Color, value: String, valueLabel: String) -> some View {
        NavigationLink(destination: Text(title)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: iconName)
                            .foregroundColor(color)
                            .font(.system(size: 16))
                            .frame(width: 32, height: 32)
                            .background(color.opacity(0.1))
                            .clipShape(Circle())
                        
                        Text(title)
                            .font(.headline)
                    }
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                    
                    Text(valueLabel)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
