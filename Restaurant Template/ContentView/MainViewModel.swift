import FirebaseAuth
import SwiftUI

class MainViewViewModel: ObservableObject {
    static let shared = MainViewViewModel()
    
    @Published var isAuthenticated = false
    @Published var isOwner = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
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
                
                // Check for owner claim when auth state changes
                if let user = user {
                    // Force token refresh to get latest claims
                    user.getIDTokenForcingRefresh(true) { _, error in
                        if let error = error {
                            print("Error refreshing token: \(error.localizedDescription)")
                            return
                        }
                        
                        // Check for owner claim
                        user.getIDTokenResult { result, error in
                            DispatchQueue.main.async {
                                if let error = error {
                                    print("Error getting token result: \(error.localizedDescription)")
                                    self?.isOwner = false
                                    return
                                }
                                
                                // Set isOwner based on custom claim
                                self?.isOwner = result?.claims["owner"] as? Bool ?? false
                                print("Owner claim checked: \(self?.isOwner ?? false)")
                            }
                        }
                    }
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
