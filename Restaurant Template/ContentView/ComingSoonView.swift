////
////  ComingSoonView.swift
////  Restaurant Template
////
////  Created by Connor Hill on 5/18/25.
////
//
//// 1. Create a reusable ComingSoonView component
//struct ComingSoonView: View {
//    let featureName: String
//    let systemImage: String
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject private var themeManager: ThemeManager
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            // Visual indicator
//            ZStack {
//                Circle()
//                    .fill(themeManager.primaryColor.opacity(0.1))
//                    .frame(width: 120, height: 120)
//                
//                Image(systemName: systemImage)
//                    .font(.system(size: 50))
//                    .foregroundColor(themeManager.primaryColor)
//            }
//            .padding(.top, 40)
//            
//            // Message
//            Text(featureName)
//                .font(.title)
//                .fontWeight(.bold)
//                .foregroundColor(themeManager.textColor)
//            
//            Text("This feature is coming soon!")
//                .font(.headline)
//                .foregroundColor(themeManager.textColor.opacity(0.7))
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 32)
//            
//            Text("We're working hard to bring you this feature in a future update.")
//                .font(.body)
//                .foregroundColor(themeManager.textColor.opacity(0.6))
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 32)
//            
//            // Back button
//            Button(action: { dismiss() }) {
//                Text("Go Back")
//                    .font(.headline)
//                    .foregroundColor(themeManager.textColor)
//                    .padding(.vertical, 12)
//                    .padding(.horizontal, 32)
//                    .background(themeManager.primaryColor.opacity(0.2))
//                    .cornerRadius(12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 12)
//                            .stroke(themeManager.primaryColor.opacity(0.3), lineWidth: 1)
//                    )
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(themeManager.backgroundGradient.ignoresSafeArea())
//    }
//}
//
//// Owner Menu Management View
//struct  OwnerMenuManagementView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Menu Management",
//            systemImage: "list.clipboard"
//        )
//    }
//}
//
//// Owner Inventory View
//struct OwnerInventoryView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Inventory Management",
//            systemImage: "cube.box"
//        )
//    }
//}
//
//// Kitchen Display View
//struct KitchenDisplayView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Kitchen Display",
//            systemImage: "flame"
//        )
//    }
//}
//
//// Profile View
//struct ProfileView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Profile",
//            systemImage: "person.circle"
//        )
//    }
//}
//
//// Order History View
//struct OrderHistoryView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Order History",
//            systemImage: "clock.arrow.circlepath"
//        )
//    }
//}
//
//// Notifications View
//struct NotificationsView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Notifications",
//            systemImage: "bell"
//        )
//    }
//}
//
//// Reports Detail View
//struct ReportsDetailView: View {
//    let reportTitle: String
//    
//    var body: some View {
//        ComingSoonView(
//            featureName: "\(reportTitle) Report",
//            systemImage: "chart.bar"
//        )
//    }
//}
//
//// Help Support View
//struct HelpSupportView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Help & Support",
//            systemImage: "questionmark.circle"
//        )
//    }
//}
//
//// Payment Management View
//struct PaymentManagementView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Payment Methods",
//            systemImage: "creditcard"
//        )
//    }
//}
//
//// Promotions View
//struct PromotionsView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Promotions",
//            systemImage: "tag"
//        )
//    }
//}
//
//// Table Reservation Management View
//struct TableReservationManagementView: View {
//    var body: some View {
//        ComingSoonView(
//            featureName: "Reservation Management",
//            systemImage: "calendar"
//        )
//    }
//}
//
//// 3. Update the navigation in OwnerSettingsView to use these views
//
//// In OwnerSettingsView, update the navigation links:
//NavigationLink(destination: StaffManagementView()) {
//    SettingRow(icon: "person.3.fill", title: "Manage Staff")
//}
//
//// 4. For Owner Dashboard, ensure navigation buttons go to filled views
//
//// In OwnerDashboardView, update the navigation:
//Button(action: {
//    selectedTab = "analytics" // Use existing view
//}) {
//    // Button content
//}
//
//Button(action: {
//    selectedTab = "menu" // Or navigate to OwnerMenuManagementView()
//}) {
//    // Button content
//}
