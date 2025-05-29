//
//  ReservationView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI

struct ReservationView: View {
    // Form state
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var selectedDate: Date
    @State private var calendarDisplayDate: Date
    @State private var time = Date().noon
    @State private var partySize = 2
    @State private var specialRequests = ""
    
    // UI state
    @State private var showingConfirmation = false
    @State private var isSubmitting = false
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    
    // Available time slots
    let availableTimes = stride(from: 11, to: 22, by: 0.5).map { hour -> Date in
        let components = DateComponents(hour: Int(hour), minute: hour.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 30)
        return Calendar.current.date(from: components)!
    }
    
    // Calendar helper properties
    private var calendarDays: [Int] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: calendarDisplayDate) else {
            return Array(1...31)
        }
        return Array(range)
    }
    
    // Sample busy days (in a real app, this would come from your backend)
    private let busyDays = [5, 12, 19, 25, 28]
    private let fullyBookedDays = [15, 22]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    // Calendar helper functions
    private func isSelectedDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let selectedDay = calendar.component(.day, from: selectedDate)
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)
        let displayMonth = calendar.component(.month, from: calendarDisplayDate)
        let displayYear = calendar.component(.year, from: calendarDisplayDate)
        
        // Check if the day matches and we're viewing the same month/year as the selected date
        let isMatch = day == selectedDay && selectedMonth == displayMonth && selectedYear == displayYear
        return isMatch
    }
    
    private func isPastDay(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        let dayDate = calendar.date(bySetting: .day, value: day, of: calendarDisplayDate) ?? calendarDisplayDate
        return dayDate < calendar.startOfDay(for: today)
    }
    
    private func getAvailabilityColor(for day: Int) -> Color {
        if isPastDay(day) {
            return Color.clear // No indicator for past days
        } else if fullyBookedDays.contains(day) {
            return .red // Fully booked
        } else if busyDays.contains(day) {
            return .orange // Busy but available
        } else {
            return themeManager.primaryColor // Available
        }
    }
    
    private func selectDay(_ day: Int) {
        let calendar = Calendar.current
        
        // Get the year and month from calendarDisplayDate
        let displayYear = calendar.component(.year, from: calendarDisplayDate)
        let displayMonth = calendar.component(.month, from: calendarDisplayDate)
        
        // Create a new date with the selected day in the correct month/year
        var components = DateComponents()
        components.year = displayYear
        components.month = displayMonth
        components.day = day
        
        if let newDate = calendar.date(from: components) {
            selectedDate = newDate
            print("Selected date: \(selectedDate)")
            print("Selected day: \(calendar.component(.day, from: selectedDate)), month: \(calendar.component(.month, from: selectedDate))")
            print("Display month: \(calendar.component(.month, from: calendarDisplayDate))")
        }
    }
    
    // Initialize with proper date synchronization
    init() {
        // Set default time to 12:00 PM
        let defaultTime = availableTimes.first { time in
            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            return components.hour == 12 && components.minute == 0
        } ?? availableTimes[0]
        
        // Use _time because we need to initialize the State property wrapper
        _time = State(initialValue: defaultTime)
        
        // Initialize both dates to the same starting point
        let startDate = Date()
        _selectedDate = State(initialValue: startDate)
        _calendarDisplayDate = State(initialValue: startDate)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient from ThemeManager
                themeManager.backgroundGradient
                    .ignoresSafeArea()
                
                // Decorative elements
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
                        // Date & Time Section
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader("Date & Time")
                            
                            // Custom Calendar
                            VStack {
                                // Date selector with month and year
                                HStack {
                                    Button {
                                        // Previous month
                                        calendarDisplayDate = Calendar.current.date(byAdding: .month, value: -1, to: calendarDisplayDate) ?? Date()
                                    } label: {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(themeManager.textColor)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(dateFormatter.string(from: calendarDisplayDate))
                                        .font(.headline)
                                        .foregroundColor(themeManager.textColor)
                                    
                                    Spacer()
                                    
                                    Button {
                                        // Next month
                                        calendarDisplayDate = Calendar.current.date(byAdding: .month, value: 1, to: calendarDisplayDate) ?? Date()
                                    } label: {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(themeManager.textColor)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                
                                Divider()
                                    .background(themeManager.textColor)
                                
                                // Calendar view
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
                                        ForEach(calendarDays, id: \.self) { day in
                                            ZStack {
                                                // Background circle for selected day
                                                if isSelectedDay(day) {
                                                    Circle()
                                                        .fill(themeManager.textColor.opacity(0.5))
                                                        .frame(width: 32, height: 32)
                                                }
                                                
                                                // Day content
                                                VStack(spacing: 4) {
                                                    Text("\(day)")
                                                        .font(.caption)
                                                        .fontWeight(isSelectedDay(day) ? .bold : .regular)
                                                        .foregroundColor(
                                                            isPastDay(day) ?
                                                            themeManager.textColor.opacity(0.3) :
                                                            (isSelectedDay(day) ? .white : themeManager.textColor)
                                                        )
                                                    
                                                    // Availability indicator
                                                    Circle()
                                                        .fill(getAvailabilityColor(for: day))
                                                        .frame(width: 6, height: 6)
                                                }
                                            }
                                            .frame(width: 36, height: 36)
                                            .contentShape(Rectangle()) // Makes entire area tappable
                                            .onTapGesture {
                                                if !isPastDay(day) && !fullyBookedDays.contains(day) {
                                                    selectDay(day)
                                                }
                                            }
                                            .disabled(isPastDay(day) || fullyBookedDays.contains(day))
                                        }
                                    }
                                }
                                .padding()
                            }
                            
                            HStack {
                                Text("Time")
                                    .foregroundColor(themeManager.textColor)
                                Spacer()
                                Picker("Time", selection: $time) {
                                    ForEach(availableTimes, id: \.self) { time in
                                        Text(time, style: .time)
                                    }
                                }
                                .pickerStyle(.menu)
                                .accentColor(themeManager.textColor)
                                .foregroundColor(themeManager.textColor)
                            }
                            
                            HStack {
                                Text("Party Size: \(partySize) \(partySize == 1 ? "person" : "people")")
                                    .foregroundColor(themeManager.textColor)
                                Spacer()
                                Stepper("", value: $partySize, in: 1...20)
                                    .colorScheme(themeManager.currentTheme == .light ? .light : .dark)
                                    .accentColor(themeManager.primaryColor)
                                    .foregroundColor(themeManager.textColor)
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
                        
                        // Contact Information Section
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader("Contact Information")
                            
                            ZStack(alignment: .leading) {
                                TextField("", text: $name)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.85)) // Darker background
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .textContentType(.name)
                                    .autocapitalization(.words)
                                
                                if name.isEmpty {
                                    Text("Full Name")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(10)
                                        .allowsHitTesting(false)
                                }
                            }
                            
                            ZStack(alignment: .leading) {
                                TextField("", text: $email)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.85)) // Darker background
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .textContentType(.emailAddress)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                if email.isEmpty {
                                    Text("Email Address")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(10)
                                        .allowsHitTesting(false)
                                }
                            }
                            
                            ZStack(alignment: .leading) {
                                TextField("", text: $phoneNumber)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.85)) // Darker background
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .textContentType(.telephoneNumber)
                                    .keyboardType(.phonePad)
                                
                                if phoneNumber.isEmpty {
                                    Text("Phone Number")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(10)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
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

                        // Special Requests Section
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader("Special Requests? (Optional)")
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $specialRequests)
                                    .frame(minHeight: 100)
                                    .padding(10)
                                    .background(themeManager.primaryColor.opacity(0.85)) // Darker background
                                    .cornerRadius(8)
                                    .foregroundColor(themeManager.textColor)
                                    .scrollContentBackground(.hidden) // Remove default background
                                
                                if specialRequests.isEmpty {
                                    Text("Ex. Dietary restrictions, seating preferences, or special occasions...")
                                        .foregroundColor(themeManager.textColor.opacity(0.6))
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 18)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
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
                        
                        // Reserve Button
                        Button {
                            submitReservation()
                        } label: {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Text("Reserve Table")
                                    .frame(maxWidth: .infinity)
                                    .bold()
                            }
                        }
                        .disabled(isSubmitting || !isFormValid)
                        .padding()
                        .background(isFormValid ? themeManager.primaryColor.opacity(0.8) : Color.gray.opacity(0.3))
                        .foregroundColor(themeManager.textColor)
                        .cornerRadius(16)
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
                    .padding(.vertical)
                    .padding(.horizontal, 12)
                }
            }
            .navigationTitle("Reservation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(themeManager.tabBarColor, for: .navigationBar)
            .toolbarColorScheme(themeManager.currentTheme == .light ? .dark : .light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Reservation")
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme == .light ? .black : .white)
                }
            }
            .sheet(isPresented: $showingConfirmation) {
                reservationConfirmationView
            }
        }
        .onAppear {
            // Ensure both dates are synchronized when the view appears
            let today = Date()
            selectedDate = today
            calendarDisplayDate = today
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(themeManager.textColor)
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
    }
    
    // Reservation confirmation sheet
    private var reservationConfirmationView: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding(.top, 40)
                .shadow(radius: 5)
            
            Text("Reservation Confirmed!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
            
            VStack(alignment: .leading, spacing: 16) {
                reservationDetailRow(icon: "person.fill", label: "Name", value: name)
                reservationDetailRow(icon: "calendar", label: "Date", value: selectedDate.formatted(date: .long, time: .omitted))
                reservationDetailRow(icon: "clock.fill", label: "Time", value: time.formatted())
                reservationDetailRow(icon: "person.3.fill", label: "Party", value: "\(partySize) \(partySize == 1 ? "person" : "people")")
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
            
            Spacer()
            
            Button {
                showingConfirmation = false
                resetForm()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.primaryColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 40)
        }
        .background(themeManager.backgroundGradient.ignoresSafeArea())
    }
    
    private func reservationDetailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(themeManager.textColor)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(themeManager.textColor.opacity(0.7))
                Text(value)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
            }
        }
    }
    
    private func submitReservation() {
        isSubmitting = true
        
        // In a real app, you would send the reservation to your backend
        // For the template, we'll simulate a network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            showingConfirmation = true
            
            // In a real app, you would create and save a Reservation object
            let reservation = Reservation(
                id: UUID(),
                name: name,
                email: email,
                phoneNumber: phoneNumber,
                date: combineDateTime(date: selectedDate, time: time),
                time: time,
                partySize: partySize,
                specialRequests: specialRequests
            )
            print("Created reservation: \(reservation)")
        }
    }
    
    private func resetForm() {
        name = ""
        email = ""
        phoneNumber = ""
        let today = Date()
        selectedDate = today
        calendarDisplayDate = today
        time = Date().noon
        partySize = 2
        specialRequests = ""
    }
    
    private func combineDateTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents) ?? date
    }
}

// Extension to get noon time
extension Date {
    var noon: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        components.hour = 12
        components.minute = 0
        return calendar.date(from: components) ?? self
    }
}

// Model for Reservation
struct Reservation: Identifiable {
    let id: UUID
    let name: String
    let email: String
    let phoneNumber: String
    let date: Date
    let time: Date
    let partySize: Int
    let specialRequests: String
}
