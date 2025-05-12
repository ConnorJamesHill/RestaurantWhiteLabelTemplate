//
//  OwnerReservationsView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import Foundation
import SwiftUI

struct OwnerReservationsView: View {
    @State private var selectedDate = Date()
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
                        // Calendar Section
                        calendarSection
                        
                        // Reservations Summary
                        reservationSummarySection
                        
                        // Today's Reservations
                        todaysReservationsSection
                        
                        // Table Status
                        tableStatusSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Table Management")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add new reservation
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.regularMaterial)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Glassmorphism Sections
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Date")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 4)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .colorScheme(.dark) // Better visualization on dark background
                .accentColor(.white)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(16)
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
    
    private var reservationSummarySection: some View {
        HStack(spacing: 15) {
            reservationStatView(count: "8", title: "Today", iconName: "calendar", color: .blue)
            reservationStatView(count: "32", title: "This Week", iconName: "calendar.badge.clock", color: .purple)
            reservationStatView(count: "7", title: "Tables Available", iconName: "table.furniture", color: .green)
        }
    }
    
    private func reservationStatView(count: String, title: String, iconName: String, color: Color) -> some View {
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
    
    private var todaysReservationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Reservations")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 4)
            
            ForEach(1...8, id: \.self) { index in
                NavigationLink(destination: Text("Reservation Details")) {
                    reservationItemView(index: index)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func reservationItemView(index: Int) -> some View {
        let people = Int.random(in: 2...8)
        let time = Calendar.current.date(bySettingHour: Int.random(in: 17...21), minute: [00, 15, 30, 45].randomElement()!, second: 0, of: Date())!
        let lastName = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Miller", "Davis"].randomElement()!
        
        return HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(lastName) Party")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(time, style: .time)")
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                
                HStack(spacing: 12) {
                    Label("\(people) people", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Label("Table \(Int.random(in: 1...12))", systemImage: "tablecells")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                    
                    if Bool.random() {
                        Text("Special Request")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                            )
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
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
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private var tableStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Table Status")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading, 4)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(1...12, id: \.self) { tableNumber in
                    tableStatusView(tableNumber: tableNumber)
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
                        colors: [.white.opacity(0.7), .clear, .white.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private func tableStatusView(tableNumber: Int) -> some View {
        let status = ["Available", "Reserved", "Occupied", "Maintenance"].randomElement()!
        let statusColor: Color = {
            switch status {
            case "Available": return .green
            case "Reserved": return .orange
            case "Occupied": return .red
            case "Maintenance": return .gray
            default: return .primary
            }
        }()
        
        return HStack {
            Image(systemName: "tablecells")
                .foregroundColor(.white)
                .padding(8)
                .background(statusColor.opacity(0.3))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Table \(tableNumber)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(statusColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        )
        .shadow(color: statusColor.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
