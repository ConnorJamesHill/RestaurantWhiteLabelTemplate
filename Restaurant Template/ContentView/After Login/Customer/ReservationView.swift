import SwiftUI

struct ReservationView: View {
    // Form state
    @State private var name = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var date = Date().addingTimeInterval(60 * 60 * 24) // Tomorrow
    @State private var time = Date().noon
    @State private var partySize = 2
    @State private var specialRequests = ""
    
    // UI state
    @State private var showingConfirmation = false
    @State private var isSubmitting = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Enhanced blue gradient background - same as OwnerAnalyticsView
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
    
    // Available time slots
    let availableTimes = stride(from: 11, to: 22, by: 0.5).map { hour -> Date in
        let components = DateComponents(hour: Int(hour), minute: hour.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 30)
        return Calendar.current.date(from: components)!
    }
    
    // Then in init(), set the default time to one of these values
    init() {
        // Set default time to 12:00 PM
        let defaultTime = availableTimes.first { time in
            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            return components.hour == 12 && components.minute == 0
        } ?? availableTimes[0]
        
        // Use _time because we need to initialize the State property wrapper
        _time = State(initialValue: defaultTime)
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
                        // Date & Time Section
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader("Date & Time")
                            
                            DatePicker("Date", selection: $date, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                .colorScheme(.dark) // Better visualization on dark background
                                .accentColor(.white)
                            
                            HStack {
                                Text("Time")
                                    .foregroundColor(.white)
                                Spacer()
                                Picker("Time", selection: $time) {
                                    ForEach(availableTimes, id: \.self) { time in
                                        Text(time, style: .time)
                                    }
                                }
                                .pickerStyle(.menu)
                                .accentColor(.white)
                                .foregroundColor(.white)
                            }
                            
                            HStack {
                                Text("Party Size: \(partySize) \(partySize == 1 ? "person" : "people")")
                                    .foregroundColor(.white)
                                Spacer()
                                Stepper("", value: $partySize, in: 1...20)
                                    .colorScheme(.dark)
                                    .accentColor(.white)
                                    .foregroundColor(.white)
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
                            
                            TextField("Name", text: $name)
                                .textContentType(.name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Phone Number", text: $phoneNumber)
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        
                        // Special Requests Section
                        VStack(alignment: .leading, spacing: 16) {
                            sectionHeader("Special Requests (Optional)")
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $specialRequests)
                                    .frame(minHeight: 100)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                
                                if specialRequests.isEmpty {
                                    Text("Ex. Dietary restrictions, seating preferences, or special occasions...")
                                        .foregroundColor(Color.gray.opacity(0.8))
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
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
                        .background(isFormValid ? Color.white.opacity(0.2) : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [.black.opacity(0.7), .clear, .black.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 0.5
                                )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .padding()
                }
            }
            .navigationTitle("Reservation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $showingConfirmation) {
                reservationConfirmationView
            }
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
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
            
            VStack(alignment: .leading, spacing: 16) {
                reservationDetailRow(icon: "person.fill", label: "Name", value: name)
                reservationDetailRow(icon: "calendar", label: "Date", value: date.formatted(date: .long, time: .omitted))
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
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 40)
        }
        .background(backgroundGradient.ignoresSafeArea())
    }
    
    private func reservationDetailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text(value)
                    .font(.body)
                    .foregroundColor(.white)
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
                date: combineDateTime(date: date, time: time),
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
        date = Date().addingTimeInterval(60 * 60 * 24)
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
