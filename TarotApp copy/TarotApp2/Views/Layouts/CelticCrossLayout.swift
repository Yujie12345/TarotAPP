import SwiftUI

struct CelticCrossLayout: View {
    let cards: [Card]
    private let horizontalPadding: CGFloat = 30
    private let cardsInRow: CGFloat = 4 // Maximum cards that need to fit horizontally
    
    var body: some View {
        VStack(spacing: 20) { 
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - horizontalPadding
                let cardWidth = (availableWidth / cardsInRow) * 0.95 // 95% of available width per card
                let spacing = cardWidth * 0.3
                let rightColumnSpacing = cardWidth * 0.15 // Reduced spacing for right column
                
                HStack(spacing: 0) {
                    // Left side (cross formation)
                    ZStack {
                        // Card 1 ("This is it") - Base card
                        CardView(card: cards[0], width: cardWidth)
                            .zIndex(0) // Ensure it's at the bottom
                        
                        // Card 2 ("This crosses it") - Crosses over card 1
                        CardView(card: cards[1], width: cardWidth)
                            .rotationEffect(.degrees(90))
                            .zIndex(1) // Above card 1
                        
                        // Card 3 ("Crowning it") - Moved up by increasing offset
                        CardView(card: cards[2], width: cardWidth)
                            .offset(y: -cardWidth * 1.8) // Changed from 1.3 to 1.8
                            .zIndex(0)
                        
                        // Card 4 ("Resting upon") - Moved down by increasing offset
                        CardView(card: cards[3], width: cardWidth)
                            .offset(y: cardWidth * 1.8) // Changed from 1.3 to 1.8
                            .zIndex(0)
                        
                        // Card 5 ("Before")
                        CardView(card: cards[4], width: cardWidth)
                            .offset(x: -cardWidth * 1.3)
                            .zIndex(0)
                        
                        // Card 6 ("After")
                        CardView(card: cards[5], width: cardWidth)
                            .offset(x: cardWidth * 1.3)
                            .zIndex(0)
                    }
                    .frame(width: cardWidth * 3.6)
                    
                    // Right column (7-10)
                    VStack(spacing: rightColumnSpacing) {
                        // Card 10 ("The Outcome")
                        CardView(card: cards[9], width: cardWidth)
                        
                        // Card 9 ("Hopes and Fears")
                        CardView(card: cards[8], width: cardWidth)
                        
                        // Card 8 ("External Influences")
                        CardView(card: cards[7], width: cardWidth)
                        
                        // Card 7 ("Querent")
                        CardView(card: cards[6], width: cardWidth)
                    }
                    .offset(x: -cardWidth * 0.05)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 450) // Added fixed height for the GeometryReader
        }
        .padding()
    }
}

// Preview
struct CelticCrossLayout_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CelticCrossLayout(cards: (0..<10).map { index in
                Card(
                    id: index,
                    name: "Card \(index)",
                    description: "Test",
                    imageUrl: "fool",
                    keywords: [],
                    isReversed: false
                )
            })
            .padding()
        }
    }
} 

