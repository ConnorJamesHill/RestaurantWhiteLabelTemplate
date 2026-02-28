# Restaurant Template

A full featured iOS restaurant app template built with SwiftUI. This template provides everything a restaurant needs to offer customers a modern ordering, reservation, and discovery experience, plus a complete owner dashboard for managing the business. Designed for easy customization: add your client's branding, menu, and information, publish to the App Store, and hand over a ready to use app.

## Table of Contents

- [Description](#description)
- [Architecture](#architecture)
- [How To Use](#how-to-use)
- [Acknowledgements](#acknowledgements)

## Description

### Customer Experience

- **Home** — Hero section, featured items, events, welcome message, and today's hours
- **Menu** — Category browsing with grid/list views, item details, and images
- **Order** — Shopping cart, checkout flow, and Apple Pay integration
- **Reservations** — Calendar picker, time slots, party size, and special requests
- **Info** — Restaurant details, location map, contact info, business hours, and social links
- **Reviews** — Customer review system

### Owner Dashboard

- **Analytics** — Revenue charts (Swift Charts), quick stats, popular items, and recent orders
- **Menu Management** — Edit menu items and categories
- **Orders** — View and manage customer orders
- **Reservations** — Manage tables and bookings
- **Marketing** — Promotions and campaigns
- **Settings** — Restaurant configuration and branding

### Technical Highlights

- **100% SwiftUI** — Native iOS with modern declarative UI
- **MVVM architecture** — Feature based organization with clear separation of concerns
- **Firebase backend** — Auth, Firestore, and App Check for secure, scalable data
- **Role based access** — Customer vs Owner flows via Firebase custom claims
- **Theme system** — Six themes (Blue, Dark, Light, Red, Brown, Green) with glassmorphism design
- **Custom components** — Animated sidebar navigation, glass cards, gradient backgrounds
- **Apple Pay** — Ready for in app payments
- **MapKit & CoreLocation** — Location and directions
- **Light and dark mode** — Full system appearance support

### Frameworks

| Framework | Purpose |
|-----------|---------|
| SwiftUI | UI |
| Firebase (Auth, Firestore, App Check) | Backend, auth, data |
| Swift Charts | Analytics visualizations |
| MapKit | Location and maps |
| CoreLocation | Location services |
| PassKit | Apple Pay |

Firebase is added via Swift Package Manager.

### Customization

The app is built around a central `RestaurantConfiguration` model. Customizing for a new client involves updating:

- Restaurant identity (name, tagline, logo, hero image)
- Contact info (phone, email, website, address, coordinates)
- Business hours and social links
- Menu categories and items
- Theme colors

This makes it straightforward to white label the app for different restaurants while keeping a single, maintainable codebase.

## Architecture

The project is organized by feature:

```
Restaurant Template/
├── Misc/
│   ├── Restaurant_TemplateApp.swift     # App entry point
│   ├── Models/
│   │   ├── Models.swift                 # MenuItem, Order, Reservation, Review, etc.
│   │   └── RestaurantConfiguration.swift # Central branding & config
│   └── GoogleService-Info.plist
├── ContentView/
│   ├── MainView.swift                   # Auth routing, role-based navigation
│   ├── MainViewModel.swift
│   ├── ThemeManager.swift               # Theme system
│   ├── Before Login/
│   │   ├── LoginView.swift
│   │   ├── RegisterView.swift
│   │   └── View Models/
│   └── After Login/
│       ├── AnimatedSidebar.swift        # Custom sidebar navigation
│       ├── Customer/                     # Customer-facing views
│       │   ├── CustomerView.swift
│       │   ├── HomeView.swift
│       │   ├── MenuView.swift
│       │   ├── OrderView.swift
│       │   ├── ReservationView.swift
│       │   ├── InfoView.swift
│       │   └── ReviewsView.swift
│       └── Owner/                       # Owner dashboard
│           ├── OwnerDashboardView.swift
│           ├── OwnerAnalyticsView.swift
│           ├── OwnerMenuView.swift
│           ├── OwnerOrdersView.swift
│           ├── OwnerReservationsView.swift
│           ├── OwnerMarketingView.swift
│           └── OwnerSettingsView.swift
```

## How To Use

### Clone the repo

```bash
git clone https://github.com/ConnorJamesHill/Restaurant-Template.git
```

### Open in Xcode

Open `Restaurant Template.xcodeproj` in Xcode.

### Add required config

1. **Firebase** — Add your `GoogleService-Info.plist` from the [Firebase Console](https://console.firebase.google.com/)
2. **Firebase Auth** — Enable Email/Password sign in in the Firebase Console
3. **Firestore** — Create a Firestore database and configure security rules
4. **Custom claims** — Set the `owner` claim for owner accounts (e.g., via Admin SDK or Cloud Functions)

### Build and run

Build and run on a device or simulator.

---

**For businesses:** This template can be customized with your restaurant's branding, menu, hours, and contact information, then published to the App Store under your business. Contact the maintainer for licensing and white label options.

## Acknowledgements

- [Firebase](https://firebase.google.com/)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Swift Charts](https://developer.apple.com/documentation/charts)
