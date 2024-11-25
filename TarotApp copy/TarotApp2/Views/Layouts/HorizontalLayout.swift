import SwiftUI

struct HorizontalLayout: View {
    let cards: [Card]
    private let horizontalPadding: CGFloat = 30
    private let cardsInRow: CGFloat = 3 // Number of cards in the row
    
    var body: some View {
        VStack(spacing: 10) {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - horizontalPadding
                let cardWidth = (availableWidth / cardsInRow) * 0.95 // 95% of available width per card
                let spacing = cardWidth * 0.3
                
                HStack(spacing: spacing) {
                    ForEach(0..<3) { index in
                        CardView(card: cards[index], width: cardWidth)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: geometry.size.height)
            }
            .frame(height: 200)
        }
        .padding()
    }
}

// Preview
struct HorizontalLayout_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            HorizontalLayout(cards: [
                Card(id: 0, name: "The Fool", description: "Test", imageUrl: "fool", keywords: [], isReversed: false),
                Card(id: 1, name: "The Magician", description: "Test", imageUrl: "magician", keywords: [], isReversed: true),
                Card(id: 2, name: "High Priestess", description: "Test", imageUrl: "highpriestess", keywords: [], isReversed: false)
            ])
        }
    }
} 
