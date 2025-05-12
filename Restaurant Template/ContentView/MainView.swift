import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject private var authViewModel = MainViewViewModel.shared
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                if viewModel.isOwner {
                    OwnerDashboardView()
                        .environmentObject(viewModel)
                } else {
                    CustomerView() // Regular customer view
                        .environmentObject(viewModel)
                }
            } else {
                LoginView()
                    .environmentObject(viewModel)
            }
        }    }
}
