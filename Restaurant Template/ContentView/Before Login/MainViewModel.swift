import FirebaseAuth
import SwiftUI

class MainViewModel: ObservableObject {
    static let shared = MainViewModel()
    
    @Published var isAuthenticated = false
    @Published var isOwner = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    private init() {
        setupAuthListener()
    }
    
    func setupAuthListener() {
        // Remove any existing listener
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        // Add new listener and store the handle
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                
                // Check if user is an owner
                if let email = user?.email {
                    self?.isOwner = email.hasSuffix("@restaurant.com")
                } else {
                    self?.isOwner = false
                }
                print("Auth state changed - isAuthenticated: \(self?.isAuthenticated ?? false)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isAuthenticated = false
                self.isOwner = false
                print("Sign out successful - isAuthenticated: \(self.isAuthenticated)")
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
