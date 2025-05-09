import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject private var authViewModel = MainViewModel.shared
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.isOwner {
                    OwnerDashboardView()
                } else {
                    ContentView()
                }
            } else {
                LoginView()
            }
        }
    }
}
