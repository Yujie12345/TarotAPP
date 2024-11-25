import SwiftUI

struct ColumnLayout: View {
    let cards: [Card]
    private let horizontalPadding: CGFloat = 30
    private let cardsInRow: CGFloat = 3 // Maximum cards in any row
    
    var body: some View {
        VStack(spacing: 20) {
            
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - horizontalPadding
                let cardWidth = (availableWidth / cardsInRow) * 0.95 // 95% of available width per card
                let spacing = cardWidth * 0.1
                
                VStack(spacing: spacing) {
                    // Top row
                    HStack {
                        Spacer()
                        CardView(card: cards[6], width: cardWidth)
                        Spacer()
                    }
                    
                    // Middle row
                    HStack(spacing: spacing * 2) {
                        CardView(card: cards[1], width: cardWidth)
                        CardView(card: cards[2], width: cardWidth)
                        CardView(card: cards[0], width: cardWidth)
                    }
                    
                    // Bottom row
                    HStack(spacing: spacing * 2) {
                        CardView(card: cards[5], width: cardWidth)
                        CardView(card: cards[3], width: cardWidth)
                        CardView(card: cards[4], width: cardWidth)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height)
            }
            .frame(height: 450)
        }
        .padding()
    }
}

// Preview
struct ColumnLayout_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            ColumnLayout(cards: (0..<7).map { index in
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
