import SwiftUI

struct DecisionLayout: View {
    let cards: [Card]
    private let horizontalPadding: CGFloat = 30
    private let cardsInRow: CGFloat = 3 // Maximum cards in a row (left column, center, right column)
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - horizontalPadding
                let cardWidth = (availableWidth / cardsInRow) * 0.95 // 95% of available width per card
                let spacing = cardWidth * 0.3
                
                HStack(spacing: spacing) {
                    // "If you do it" column
                    VStack(spacing: spacing) {
                        ForEach(0..<3) { index in
                            CardView(card: cards[index], width: cardWidth)
                        }
                    }
                    
                    // Center card - Key Factor
                    CardView(card: cards[3], width: cardWidth)
                    
                    // "If you don't" column
                    VStack(spacing: spacing) {
                        ForEach(4..<7) { index in
                            CardView(card: cards[index], width: cardWidth)
                        }
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
struct DecisionLayout_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            DecisionLayout(cards: [
                Card(id: 0, name: "The Fool", description: "Test", imageUrl: "fool", keywords: [], isReversed: false),
                Card(id: 1, name: "The Magician", description: "Test", imageUrl: "magician", keywords: [], isReversed: true),
                Card(id: 2, name: "High Priestess", description: "Test", imageUrl: "highpriestess", keywords: [], isReversed: false),
                Card(id: 3, name: "The Empress", description: "Test", imageUrl: "empress", keywords: [], isReversed: false),
                Card(id: 4, name: "The Emperor", description: "Test", imageUrl: "emperor", keywords: [], isReversed: true),
                Card(id: 5, name: "The Hierophant", description: "Test", imageUrl: "hierophant", keywords: [], isReversed: false),
                Card(id: 6, name: "The Lovers", description: "Test", imageUrl: "lovers", keywords: [], isReversed: false)
            ])
        }
    }
} 
