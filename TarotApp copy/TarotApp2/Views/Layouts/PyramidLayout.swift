import SwiftUI

struct PyramidLayout: View {
    let cards: [Card]
    private let horizontalPadding: CGFloat = 30
    private let cardsInRow: CGFloat = 3 // Maximum cards in a row (bottom row)
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - horizontalPadding
                let cardWidth = (availableWidth / cardsInRow) * 0.95 // 95% of available width per card
                let spacing = cardWidth * 0.3
                
                VStack(spacing: spacing) {
                    // Top card
                    HStack {
                        Spacer()
                        CardView(card: cards[0], width: cardWidth)
                        Spacer()
                    }
                    
                    // Middle row (2 cards)
                    HStack(spacing: spacing * 2) {
                        CardView(card: cards[1], width: cardWidth)
                        CardView(card: cards[2], width: cardWidth)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Bottom row (3 cards)
                    HStack(spacing: spacing) {
                        CardView(card: cards[3], width: cardWidth)
                        CardView(card: cards[4], width: cardWidth)
                        CardView(card: cards[5], width: cardWidth)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height)
            }
            .frame(height: 400)
        }
        .padding()
    }
}

// Preview
struct PyramidLayout_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            PyramidLayout(cards: (0..<6).map { index in
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
