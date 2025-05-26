//
//  OwnerReservationsView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/11/25.
//

import SwiftUI

struct OwnerReservationsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedDate = Date()
    @State private var selectedReservation: ReservationData? = nil
    
    // Sample reservation data
    let reservations = [
        ReservationData(
            id: "R1001",
            customerName: "John Smith",
            people: 4,
            time: "6:30 PM",
            status: .confirmed,
            phoneNumber: "555-123-4567"
        ),
        ReservationData(
            id: "R1002",
            customerName: "Sarah Johnson",
            people: 2,
            time: "7:00 PM",
            status: .pending,
            phoneNumber: "555-234-5678"
        ),
        ReservationData(
            id: "R1003",
            customerName: "Michael Brown",
            people: 6,
            time: "8:00 PM",
            status: .confirmed,
            phoneNumber: "555-345-6789"
        ),
        ReservationData(
            id: "R1004",
            customerName: "Emily Chen",
            people: 3,
            time: "6:00 PM",
            status: .cancelled,
            phoneNumber: "555-456-7890"
        ),
        ReservationData(
            id: "R1005",
            customerName: "David Wilson",
            people: 2,
            time: "7:30 PM",
            status: .confirmed,
            phoneNumber: "555-567-8901"
        )
    ]
    
    // Summary stats
    let totalTables = 12
    let reservedTables = 8
    let pendingReservations = 2
    let totalCovers = 24
    
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
            
            // Reservation Detail Sheet
            if let selectedReservation = selectedReservation {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.selectedReservation = nil
                    }
                
                ReservationDetailView(reservation: selectedReservation, isShowing: $selectedReservation)
            }
        }
    }
    
    // MARK: - Calendar Section
    var calendarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reservations Calendar")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            GlassCard {
                VStack {
                    // Date selector with month and year
                    HStack {
                        Button {
                            // Previous month
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(themeManager.primaryColor)
                        }
                        
                        Spacer()
                        
                        Text(dateFormatter.string(from: selectedDate))
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                        
                        Button {
                            // Next month
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(themeManager.primaryColor)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    
                    Divider()
                        .background(themeManager.textColor.opacity(0.2))
                    
                    // Weekly calendar view
                    VStack(spacing: 12) {
                        // Days of week header
                        HStack(spacing: 0) {
                            ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(themeManager.textColor.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        // Calendar days grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
                            ForEach(-3..<32) { day in
                                VStack {
                                    Text("\(day + 1)")
                                        .font(.caption)
                                        .fontWeight(day == Calendar.current.component(.day, from: Date()) - 1 ? .bold : .regular)
                                        .foregroundColor(
                                            day < 0 || day >= 30 ?
                                            themeManager.textColor.opacity(0.3) :
                                            themeManager.textColor
                                        )
                                    
                                    // Indicator for reservations
                                    if [1, 4, 7, 10, 15, 22, 28].contains(day) {
                                        Circle()
                                            .fill(themeManager.primaryColor)
                                            .frame(width: 6, height: 6)
                                    } else {
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 6, height: 6)
                                    }
                                }
                                .frame(height: 36)
                                .background(
                                    day == 15 ?
                                    Circle().fill(themeManager.primaryColor.opacity(0.2)) :
                                    Circle().fill(Color.clear)
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Reservations Summary
    var reservationSummarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Summary")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            HStack(spacing: 12) {
                // Reserved Tables
                SummaryCard(
                    title: "Reserved Tables",
                    value: "\(reservedTables)/\(totalTables)",
                    icon: "tablecells.fill",
                    color: themeManager.primaryColor
                )
                
                // Total Covers
                SummaryCard(
                    title: "Total Covers",
                    value: "\(totalCovers)",
                    icon: "person.2.fill",
                    color: themeManager.secondaryColor
                )
            }
        }
    }
    
    // MARK: - Today's Reservations
    var todaysReservationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Reservations")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            GlassCard {
                VStack(spacing: 0) {
                    ForEach(reservations) { reservation in
                        Button {
                            selectedReservation = reservation
                        } label: {
                            HStack(spacing: 16) {
                                // Time
                                Text(reservation.time)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(themeManager.textColor)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(reservation.customerName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "person.2.fill")
                                            .font(.caption2)
                                            .foregroundColor(themeManager.primaryColor)
                                        
                                        Text("\(reservation.people) people")
                                            .font(.caption)
                                            .foregroundColor(themeManager.textColor.opacity(0.7))
                                    }
                                }
                                
                                Spacer()
                                
                                ReservationStatusBadge(status: reservation.status)
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(themeManager.textColor.opacity(0.5))
                                    .font(.caption)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if reservation.id != reservations.last?.id {
                            Divider()
                                .background(themeManager.textColor.opacity(0.2))
                                .padding(.leading)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table Status
    var tableStatusSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Table Status")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
                .padding(.leading, 8)
            
            GlassCard {
                // Table grid layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 16)], spacing: 16) {
                    ForEach(1...totalTables, id: \.self) { tableNumber in
                        TableStatusCell(tableNumber: tableNumber, isOccupied: tableNumber <= reservedTables)
                    }
                }
                .padding()
            }
        }
    }
    
    // MARK: - Helper Views
    
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
                                colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.15
                        )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    struct SummaryCard: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let title: String
        let value: String
        let icon: String
        let color: Color
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(color)
                    
                    Spacer()
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
                            colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    struct TableStatusCell: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let tableNumber: Int
        let isOccupied: Bool
        
        var body: some View {
            VStack(spacing: 8) {
                Text("\(tableNumber)")
                    .font(.headline)
                    .foregroundColor(isOccupied ? .white : themeManager.textColor)
                
                Text(isOccupied ? "Occupied" : "Available")
                    .font(.caption)
                    .foregroundColor(isOccupied ? .white.opacity(0.8) : themeManager.textColor.opacity(0.7))
            }
            .frame(height: 90)
            .frame(maxWidth: .infinity)
            .background(
                isOccupied ?
                themeManager.primaryColor :
                themeManager.textColor.opacity(0.1)
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isOccupied ?
                        themeManager.primaryColor.opacity(0.5) :
                        themeManager.textColor.opacity(0.2),
                        lineWidth: 0.5
                    )
            )
            .shadow(
                color: isOccupied ? themeManager.primaryColor.opacity(0.3) : Color.clear,
                radius: 6,
                x: 0,
                y: 3
            )
        }
    }
    
    struct ReservationStatusBadge: View {
        let status: ReservationStatus
        
        var body: some View {
            Text(status.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(status.textColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(status.backgroundColor)
                .cornerRadius(8)
        }
    }
    
    struct ReservationDetailView: View {
        @EnvironmentObject private var themeManager: ThemeManager
        let reservation: ReservationData
        @Binding var isShowing: ReservationData?
        
        var body: some View {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Reservation Details")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.textColor)
                    
                    ReservationStatusBadge(status: reservation.status)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(themeManager.primaryColor.opacity(0.1))
                
                // Content
                VStack(spacing: 20) {
                    // Customer info
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Customer Information")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                        
                        HStack(spacing: 20) {
                            DetailItem(icon: "person.fill", title: "Name", value: reservation.customerName)
                            
                            DetailItem(icon: "phone.fill", title: "Phone", value: reservation.phoneNumber)
                        }
                    }
                    .padding(.top)
                    
                    Divider()
                        .background(themeManager.textColor.opacity(0.2))
                    
                    // Reservation details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Reservation Details")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(themeManager.textColor)
                        
                        HStack(spacing: 20) {
                            DetailItem(icon: "calendar", title: "Date", value: "Today")
                            
                            DetailItem(icon: "clock.fill", title: "Time", value: reservation.time)
                            
                            DetailItem(icon: "person.2.fill", title: "People", value: "\(reservation.people)")
                        }
                    }
                    
                    Divider()
                        .background(themeManager.textColor.opacity(0.2))
                    
                    // Actions
                    HStack(spacing: 12) {
                        actionButton(title: "Call Customer", icon: "phone.fill", color: themeManager.primaryColor) {
                            // Call action
                        }
                        
                        actionButton(title: "Send Message", icon: "message.fill", color: themeManager.secondaryColor) {
                            // Message action
                        }
                    }
                    
                    if reservation.status == .pending {
                        HStack(spacing: 12) {
                            actionButton(title: "Confirm", icon: "checkmark.circle.fill", color: .green) {
                                // Confirm action
                            }
                            
                            actionButton(title: "Cancel", icon: "xmark.circle.fill", color: .red) {
                                // Cancel action
                            }
                        }
                    } else if reservation.status == .confirmed {
                        actionButton(title: "Mark as Arrived", icon: "figure.walk.circle.fill", color: .green) {
                            // Mark as arrived action
                        }
                    }
                }
                .padding()
                
                // Close button
                Button {
                    isShowing = nil
                } label: {
                    Text("Close")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textColor)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .padding()
            }
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [.black.opacity(0.5), .clear, .black.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.15
                    )
            )
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: 500)
        }
        
        // Helper views
        struct DetailItem: View {
            @EnvironmentObject private var themeManager: ThemeManager
            let icon: String
            let title: String
            let value: String
            
            var body: some View {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: icon)
                            .font(.caption)
                            .foregroundColor(themeManager.primaryColor)
                        
                        Text(title)
                            .font(.caption)
                            .foregroundColor(themeManager.textColor.opacity(0.7))
                    }
                    
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.textColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
        func actionButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.subheadline)
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(12)
                .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - Utilities
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }
}

// MARK: - Supporting Types

struct ReservationData: Identifiable {
    let id: String
    let customerName: String
    let people: Int
    let time: String
    let status: ReservationStatus
    let phoneNumber: String
}

enum ReservationStatus: String {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case cancelled = "Cancelled"
    case completed = "Completed"
    
    var backgroundColor: Color {
        switch self {
        case .pending: return Color.orange.opacity(0.2)
        case .confirmed: return Color.green.opacity(0.2)
        case .cancelled: return Color.red.opacity(0.2)
        case .completed: return Color.blue.opacity(0.2)
        }
    }
    
    var textColor: Color {
        switch self {
        case .pending: return .orange
        case .confirmed: return .green
        case .cancelled: return .red
        case .completed: return .blue
        }
    }
}
