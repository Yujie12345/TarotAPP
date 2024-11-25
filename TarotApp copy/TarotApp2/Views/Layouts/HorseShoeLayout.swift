import SwiftUI

struct HorseShoeLayout: View {
    let cards: [Card]
    private let horizontalPadding: CGFloat = 30
    private let cardsInRow: CGFloat = 3 // Maximum cards in a row
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - horizontalPadding
                let cardWidth = (availableWidth / cardsInRow) * 0.95
                let spacing = cardWidth * 0.2
                
                VStack(spacing: spacing * 0.5) {
                    // Top row - Card 4 (Obstacles)
                    HStack {
                        Spacer()
                        CardView(card: cards[3], width: cardWidth) // Card 4
                        Spacer()
                    }
                    
                    // Second row - Cards 3 and 5
                    HStack(spacing: spacing) {
                        CardView(card: cards[2], width: cardWidth) // Card 3
                        Spacer()
                        CardView(card: cards[4], width: cardWidth) // Card 5
                    }
                    
                    // Third row - Cards 2 and 6
                    HStack(spacing: spacing) {
                        CardView(card: cards[1], width: cardWidth) // Card 2
                        Spacer()
                        CardView(card: cards[5], width: cardWidth) // Card 6
                    }
                    
                    // Bottom row - Cards 1 and 7
                    HStack(spacing: spacing) {
                        CardView(card: cards[0], width: cardWidth) // Card 1
                        Spacer()
                        CardView(card: cards[6], width: cardWidth) // Card 7
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height)
            }
            .frame(height: 450) // Increased height for better spacing
        }
        .padding()
    }
}

// Preview
struct HorseShoeLayout_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            HorseShoeLayout(cards: (0..<7).map { index in
                Card(
                    id: index,
                    name: "Card \(index)",
                    description: "Test",
                    imageUrl: "fool",
                    keywords: [],
                    isReversed: false
                )
            })
        }
    }
} 
