//
//  RegisterViewViewModel.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/7/25.
//

import FirebaseAuth
import Foundation
import SwiftUI

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isOwner = false
    
    var isFormValid: Bool {
        // Trim whitespace
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
        
        // Check if fields are empty
        guard !trimmedName.isEmpty,
              !trimmedEmail.isEmpty,
              !trimmedPassword.isEmpty else {
            return false
        }
        
        // Validate name length
        guard trimmedName.count >= 3 else {
            return false
        }
        
        // Validate email format
        guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
            return false
        }
        
        // Validate password length
        guard trimmedPassword.count >= 6 else {
            return false
        }
        
        return true
    }
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            if let user = result?.user {
                // Set user display name
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = self.name
                changeRequest.commitChanges { error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
                
                // All registered users through normal flow are customers
                DispatchQueue.main.async {
                    self.isOwner = false
                }
            }
        }
    }
    
    func guestRegister() {
        // Create a temporary anonymous user
        let tempEmail = "guest_\(UUID().uuidString)@temp.com"
        let tempPassword = UUID().uuidString
        
        Auth.auth().createUser(withEmail: tempEmail, password: tempPassword) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Guest registration error: \(error.localizedDescription)")
                    self?.errorMessage = "Unable to continue as guest. Please try again."
                    return
                }
                
                if let user = result?.user {
                    print("Guest registration successful: \(user.uid)")
                    self?.isOwner = false
                }
            }
        }
    }
    
    private func validate() -> Bool {
        // Trim whitespace
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
        
        // Check if fields are empty
        guard !trimmedName.isEmpty,
              !trimmedEmail.isEmpty,
              !trimmedPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        // Validate name length
        guard trimmedName.count >= 3 else {
            errorMessage = "Name must be at least 3 characters"
            return false
        }
        
        // Validate email format
        guard trimmedEmail.contains("@") && trimmedEmail.contains(".") else {
            errorMessage = "Please enter a valid email"
            return false
        }
        
        // Validate password length
        guard trimmedPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return false
        }
        
        return true
    }
}

struct InitialSetupView: View {
    @State private var ownerEmail = ""
    @State private var ownerPassword = ""
    @State private var restaurantName = ""
    @State private var setupCode = "" // Provided to the restaurant
    
    var body: some View {
        Form {
            Section(header: Text("Restaurant Information")) {
                TextField("Restaurant Name", text: $restaurantName)
            }
            
            Section(header: Text("Owner Account")) {
                TextField("Owner Email", text: $ownerEmail)
                SecureField("Owner Password", text: $ownerPassword)
                TextField("Setup Code", text: $setupCode)
            }
            
            Button("Complete Setup") {
                createOwnerAccount()
            }
        }
    }
    
    private func createOwnerAccount() {
        // 1. Verify setup code
        // 2. Create owner account
        // 3. Set custom claims through Cloud Function
        // 4. Initialize restaurant configuration
    }
}
