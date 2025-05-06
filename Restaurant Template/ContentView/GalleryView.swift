//
//  GalleryView.swift
//  Restaurant Template
//
//  Created by Connor Hill on 5/4/25.
//

import SwiftUI

struct GalleryView: View {
    // Sample gallery data - in a real app, load from backend
    let photoCategories = [
        PhotoCategory(name: "Food", photos: [
            Photo(id: UUID(), name: "Signature Pasta", image: "food_1"),
            Photo(id: UUID(), name: "Grilled Salmon", image: "food_2"),
            Photo(id: UUID(), name: "Chocolate Dessert", image: "food_3"),
            Photo(id: UUID(), name: "Appetizer Platter", image: "food_4")
        ]),
        PhotoCategory(name: "Interior", photos: [
            Photo(id: UUID(), name: "Dining Area", image: "interior_1"),
            Photo(id: UUID(), name: "Bar", image: "interior_2"),
            Photo(id: UUID(), name: "Private Room", image: "interior_3")
        ]),
        PhotoCategory(name: "Events", photos: [
            Photo(id: UUID(), name: "Wine Tasting", image: "event_1"),
            Photo(id: UUID(), name: "Chef's Table", image: "event_2"),
            Photo(id: UUID(), name: "Holiday Celebration", image: "event_3")
        ])
    ]
    
    @State private var selectedCategory: PhotoCategory?
    @State private var selectedPhoto: Photo?
    @State private var showingFullScreen = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    ForEach(photoCategories, id: \.name) { category in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(category.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(category.photos) { photo in
                                        photoThumbnail(photo: photo)
                                            .onTapGesture {
                                                selectedPhoto = photo
                                                selectedCategory = category
                                                showingFullScreen = true
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Gallery")
            .fullScreenCover(isPresented: $showingFullScreen) {
                if let category = selectedCategory, let photo = selectedPhoto {
                    fullScreenGalleryView(category: category, initialPhoto: photo)
                }
            }
        }
    }
    
    private func photoThumbnail(photo: Photo) -> some View {
        VStack(alignment: .leading) {
            Image(photo.image)
                .resizable()
                .scaledToFill()
                .frame(width: 280, height: 180)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            
            Text(photo.name)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
    
    private func fullScreenGalleryView(category: PhotoCategory, initialPhoto: Photo) -> some View {
        FullScreenGalleryView(
            photos: category.photos,
            initialPhoto: initialPhoto,
            dismissAction: { showingFullScreen = false }
        )
    }
}

// Full screen gallery view with paging
struct FullScreenGalleryView: View {
    let photos: [Photo]
    let initialPhoto: Photo
    let dismissAction: () -> Void
    
    @State private var currentIndex: Int
    @State private var showControls = true
    
    init(photos: [Photo], initialPhoto: Photo, dismissAction: @escaping () -> Void) {
        self.photos = photos
        self.initialPhoto = initialPhoto
        self.dismissAction = dismissAction
        
        // Find the initial index
        if let index = photos.firstIndex(where: { $0.id == initialPhoto.id }) {
            _currentIndex = State(initialValue: index)
        } else {
            _currentIndex = State(initialValue: 0)
        }
    }
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.ignoresSafeArea()
            
            // Image pager
            TabView(selection: $currentIndex) {
                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                    ZoomableScrollView {
                        Image(photo.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: showControls ? .automatic : .never))
            
            // Controls overlay
            if showControls {
                VStack {
                    HStack {
                        Button(action: dismissAction) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        Text("\(currentIndex + 1)/\(photos.count)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(15)
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    Text(photos[currentIndex].name)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0)]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                }
            }
        }
        .onTapGesture {
            withAnimation {
                showControls.toggle()
            }
        }
    }
}

// Zoomable scroll view for images
struct ZoomableScrollView<Content: View>: UIViewRepresentable {
    private var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        // Set up the UIScrollView
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Create a UIHostingController to hold the SwiftUI content
        let hostedView = context.coordinator.hostingController.view!
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(hostedView)
        
        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            hostedView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update the hosting controller's SwiftUI content
        context.coordinator.hostingController.rootView = content
        
        // Make sure we scale back to the minimum zoom level if the view changes
        context.coordinator.updateContentSize(viewSize: uiView.bounds.size)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(hostingController: UIHostingController(rootView: content))
    }
    
    // The coordinator class handles zooming and layout
    class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>
        
        init(hostingController: UIHostingController<Content>) {
            self.hostingController = hostingController
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return hostingController.view
        }
        
        func updateContentSize(viewSize: CGSize) {
            hostingController.view.frame.size = viewSize
        }
    }
}

// MARK: - Models

struct PhotoCategory {
    let name: String
    let photos: [Photo]
}

struct Photo: Identifiable {
    let id: UUID
    let name: String
    let image: String  // Image name in assets
}
