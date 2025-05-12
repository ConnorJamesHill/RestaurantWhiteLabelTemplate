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
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Table Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add new reservation
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    // MARK: - Sections
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Date")
                .font(.headline)
                .padding(.leading, 4)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                .foregroundColor(color)
                .font(.system(size: 20))
            
            Text(count)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var todaysReservationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Reservations")
                .font(.headline)
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
                    
                    Spacer()
                    
                    Text("\(time, style: .time)")
                        .font(.system(.subheadline, design: .monospaced))
                        .fontWeight(.semibold)
                }
                
                HStack(spacing: 12) {
                    Label("\(people) people", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("Table \(Int.random(in: 1...12))", systemImage: "tablecells")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if Bool.random() {
                        Text("Special Request")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(4)
                    }
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
    
    private var tableStatusSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Table Status")
                .font(.headline)
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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                .foregroundColor(statusColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Table \(tableNumber)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(statusColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(statusColor.opacity(0.05))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
