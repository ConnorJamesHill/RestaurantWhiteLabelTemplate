import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    enum AppTheme: String, CaseIterable, Identifiable {
        case blue = "Blue"
        case dark = "Dark"
        case light = "Light"
        case red = "Red"
        case brown = "Brown"
        case green = "Green"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .blue: return "circle.fill"
            case .dark: return "moon.fill"
            case .light: return "sun.max.fill"
            case .red: return "flame.fill"
            case .brown: return "leaf.fill"
            case .green: return "leaf.circle.fill"
            }
        }
    }
    
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "appTheme")
            updateAppearance()
        }
    }
    
    // MARK: - Theme Properties
    
    var backgroundGradient: LinearGradient {
        switch currentTheme {
        case .blue:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "1a73e8"), Color(hex: "0d47a1"), Color(hex: "002171"), Color(hex: "002984")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .dark:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "121212"), Color(hex: "1E1E1E"), Color(hex: "2C2C2C"), Color(hex: "3B3B3B")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .light:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "F5F5F5"), Color(hex: "E0E0E0"), Color(hex: "BDBDBD"), Color(hex: "9E9E9E")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .red:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "E53935"), Color(hex: "C62828"), Color(hex: "B71C1C"), Color(hex: "891212")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .brown:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "8D6E63"), Color(hex: "6D4C41"), Color(hex: "5D4037"), Color(hex: "4E342E")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .green:
            return LinearGradient(
                gradient: Gradient(colors: [Color(hex: "43A047"), Color(hex: "2E7D32"), Color(hex: "1B5E20"), Color(hex: "0D3E10")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var primaryColor: Color {
        switch currentTheme {
        case .blue: return Color(hex: "1a73e8")
        case .dark: return Color(hex: "424242")
        case .light: return Color(hex: "BDBDBD")
        case .red: return Color(hex: "E53935")
        case .brown: return Color(hex: "8D6E63")
        case .green: return Color(hex: "43A047")
        }
    }
    
    var secondaryColor: Color {
        switch currentTheme {
        case .blue: return Color(hex: "002984")
        case .dark: return Color(hex: "212121")
        case .light: return Color(hex: "E0E0E0")
        case .red: return Color(hex: "B71C1C")
        case .brown: return Color(hex: "5D4037")
        case .green: return Color(hex: "1B5E20")
        }
    }
    
    var textColor: Color {
        switch currentTheme {
        case .light: return .black
        default: return .white
        }
    }
    
    var tabBarColor: Color {
        switch currentTheme {
        case .blue: return Color(hex: "0d47a1").opacity(0.7)
        case .dark: return Color(hex: "212121").opacity(0.7)
        case .light: return Color(hex: "E0E0E0").opacity(0.7)
        case .red: return Color(hex: "C62828").opacity(0.7)
        case .brown: return Color(hex: "6D4C41").opacity(0.7)
        case .green: return Color(hex: "2E7D32").opacity(0.7)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        // Load saved theme or use default blue
        if let savedTheme = UserDefaults.standard.string(forKey: "appTheme"),
           let theme = AppTheme(rawValue: savedTheme) {
            self.currentTheme = theme
        } else {
            self.currentTheme = .blue
        }
        
        // Apply theme on launch
        updateAppearance()
    }
    
    // MARK: - Theme Management

    func updateAppearance() {
        // Update navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundEffect = UIBlurEffect(style: currentTheme == .light ? .systemThinMaterial : .systemThinMaterialDark)
        navBarAppearance.backgroundColor = UIColor(tabBarColor)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(textColor)]
        navBarAppearance.shadowColor = .clear
        
        // Apply the appearance to all navigation bars
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        // Update tab bar appearance (for consistency)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: currentTheme == .light ? .systemThinMaterial : .systemThinMaterialDark)
        tabBarAppearance.backgroundColor = UIColor(tabBarColor)
        
        // Style tab items
        let textColorUI = UIColor(textColor)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = textColorUI.withAlphaComponent(0.5)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: textColorUI.withAlphaComponent(0.5)]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = textColorUI
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: textColorUI]
        
        // Apply to tab bar
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = textColorUI
    }
}
