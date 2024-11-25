import SwiftUI

struct CardView: View {
    let card: Card
    let width: CGFloat
    
    var body: some View {
        Image(card.fullImageName)
            .resizable()
            .aspectRatio(2/3, contentMode: .fit)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            .frame(width: width)
            .rotationEffect(card.isReversed ? .degrees(180) : .degrees(0))
    }
}

// Preview provider
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            let cardWidth = (geometry.size.width - 30) / 3 * 0.95
            
            ZStack {
                
                VStack(spacing: 20) {
                    // Upright card
                    CardView(
                        card: Card(
                            id: 0,
                            name: "The Fool",
                            description: "New beginnings",
                            imageUrl: "fool",
                            keywords: ["beginnings"],
                            isReversed: false
                        ),
                        width: cardWidth
                    )
                    
                    // Reversed card
                    CardView(
                        card: Card(
                            id: 1,
                            name: "The Magician",
                            description: "Manifestation",
                            imageUrl: "magician",
                            keywords: ["power"],
                            isReversed: true
                        ),
                        width: cardWidth
                    )
                }
            }
        }
    }
} 
