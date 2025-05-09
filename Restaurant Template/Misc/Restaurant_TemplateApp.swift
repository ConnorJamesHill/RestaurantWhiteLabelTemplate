import SwiftUI
import FirebaseCore
import FirebaseAppCheck

@main
struct Restaurant_TemplateApp: App {
    @StateObject private var restaurantConfig = RestaurantConfiguration.shared
    @StateObject private var authViewModel = MainViewModel.shared
    
    init() {
        // Configure App Check for development
        #if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif
        
        // Configure Firebase
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
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
            .environmentObject(restaurantConfig)
        }
    }
}
