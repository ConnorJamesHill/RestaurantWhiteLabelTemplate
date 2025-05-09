//
//  RegisterViewViewModel.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/7/25.
//

import FirebaseAuth
import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isOwner = false
    
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
                
                // Check if registering as owner
                DispatchQueue.main.async {
                    self.isOwner = self.email.contains("@restaurant.com")
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
