import SwiftUI

struct ReviewsView: View {
    // Sample reviews data - in a real app, load from backend
    @State private var reviews = [
        Review(id: UUID(), userName: "Sarah T.", rating: 5, comment: "Absolutely amazing food and atmosphere! The chef's special was divine and the service was impeccable. Will definitely be back soon.", date: Date().addingTimeInterval(-60*60*24*2)),
        Review(id: UUID(), userName: "Michael R.", rating: 4, comment: "Great experience overall. The pasta was delicious and the wine selection is excellent. Service was a bit slow but staff were very friendly.", date: Date().addingTimeInterval(-60*60*24*7)),
        Review(id: UUID(), userName: "Jessica L.", rating: 5, comment: "Best restaurant in town! We celebrated our anniversary here and the staff made it so special. The food was outstanding.", date: Date().addingTimeInterval(-60*60*24*14)),
        Review(id: UUID(), userName: "David M.", rating: 3, comment: "Good food but a bit overpriced. The ambiance is nice though. Might come back to try the new menu.", date: Date().addingTimeInterval(-60*60*24*30))
    ]
    
    @State private var newReviewShown = false
    @State private var userRating = 0
    @State private var userName = ""
    @State private var userComment = ""
    
    var averageRating: Double {
        if reviews.isEmpty {
            return 0
        }
        let sum = reviews.reduce(0) { $0 + $1.rating }
        return Double(sum) / Double(reviews.count)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Rating summary
                ratingSummaryView
                
                // List of reviews
                List {
                    ForEach(reviews.sorted(by: { $0.date > $1.date })) { review in
                        ReviewCell(review: review)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Reviews")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newReviewShown = true
                    } label: {
                        Text("Add Review")
                    }
                }
            }
            .sheet(isPresented: $newReviewShown) {
                writeReviewView
            }
        }
    }
    
    private var ratingSummaryView: some View {
        VStack(spacing: 12) {
            Text("Average Rating")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.1f", averageRating))
                    .font(.system(size: 48, weight: .bold))
                
                Text("/ 5")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= Int(averageRating.rounded()) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            
            Text("\(reviews.count) \(reviews.count == 1 ? "review" : "reviews")")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
    
    private var writeReviewView: some View {
        NavigationStack {
            Form {
                Section(header: Text("Your Rating")) {
                    HStack(spacing: 8) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= userRating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.title2)
                                .onTapGesture {
                                    userRating = star
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Your Name")) {
                    TextField("Name", text: $userName)
                }
                
                Section(header: Text("Your Review")) {
                    TextEditor(text: $userComment)
                        .frame(minHeight: 120)
                }
                
                Section {
                    Button {
                        submitReview()
                    } label: {
                        Text("Submit Review")
                            .frame(maxWidth: .infinity)
                            .bold()
                    }
                    .listRowBackground(isReviewValid ? Color.primary : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .disabled(!isReviewValid)
                }
            }
            .navigationTitle("Write a Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        newReviewShown = false
                    }
                }
            }
        }
    }
    
    private var isReviewValid: Bool {
        return userRating > 0 && !userName.isEmpty && !userComment.isEmpty
    }
    
    private func submitReview() {
        let newReview = Review(
            id: UUID(),
            userName: userName,
            rating: userRating,
            comment: userComment,
            date: Date()
        )
        
        reviews.append(newReview)
        
        // Reset form
        userRating = 0
        userName = ""
        userComment = ""
        
        // Close sheet
        newReviewShown = false
    }
}

struct ReviewCell: View {
    let review: Review
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(review.userName)
                        .font(.headline)
                    
                    Text(dateFormatter.string(from: review.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            Text(review.comment)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 8)
    }
}
