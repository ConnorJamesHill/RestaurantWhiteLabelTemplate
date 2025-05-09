//
//  LoginViewViewModel.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/7/25.
//

import FirebaseAuth
import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isOwner = false
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            // Check if user is an owner
            if let email = result?.user.email {
                DispatchQueue.main.async {
                    // For now, we'll use a simple domain check
                    // In a real app, you'd want to check a custom claim or database field
                    self?.isOwner = email.contains("@restaurant.com")
                }
            }
        }
    }
    
    private func validate() -> Bool {
        // Trim whitespace from email and password
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPassword = password.trimmingCharacters(in: .whitespaces)
        
        // Check if fields are empty
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
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
