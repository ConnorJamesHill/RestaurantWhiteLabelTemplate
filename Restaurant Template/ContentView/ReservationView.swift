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
    
    // Available time slots
    let availableTimes = stride(from: 11, to: 22, by: 0.5).map { hour -> Date in
        let components = DateComponents(hour: Int(hour), minute: hour.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 30)
        return Calendar.current.date(from: components)!
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Date & Time Section
                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader("Date & Time")
                        
                        DatePicker("Date", selection: $date, in: Date()..., displayedComponents: .date)
                            .datePickerStyle(.graphical)
                        
                        HStack {
                            Text("Time")
                            Spacer()
                            Picker("Time", selection: $time) {
                                ForEach(availableTimes, id: \.self) { time in
                                    Text(time, style: .time)
                                }
                            }
                            .pickerStyle(.menu)
                            .shadow(radius: 3)
                        }
                        
                        HStack {
                            Text("Party Size: \(partySize) \(partySize == 1 ? "person" : "people")")
                            Spacer()
                            Stepper("", value: $partySize, in: 1...20)
                                .shadow(radius: 3)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
                    // Contact Information Section
                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader("Contact Information")
                        
                        TextField("Name", text: $name)
                            .textContentType(.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(radius: 2)
                        
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(radius: 2)
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .shadow(radius: 2)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
                    // Special Requests Section
                    VStack(alignment: .leading, spacing: 16) {
                        sectionHeader("Special Requests (Optional)")
                        
                        TextEditor(text: $specialRequests)
                            .frame(minHeight: 100)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    
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
                    .background(isFormValid ? Color.primary : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(16)
//                    .shadow(radius: 5)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Reservation")
            .sheet(isPresented: $showingConfirmation) {
                reservationConfirmationView
            }
        }
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
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
                reservationDetailRow(icon: "clock.fill", label: "Time", value: time.formatted(date: .omitted, time: .shortened))
                reservationDetailRow(icon: "person.3.fill", label: "Party", value: "\(partySize) \(partySize == 1 ? "person" : "people")")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 5)
            
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
                    .background(Color.primary)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 40)
        }
    }
    
    private func reservationDetailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.primary)
                .shadow(radius: 2)
            
            VStack(alignment: .leading) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
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
