import Foundation

class DeckService {
    static let shared = DeckService()
    
    private init() {}
    
    func loadDeck() -> [Card] {
        guard let url = Bundle.main.url(forResource: "tarot_deck", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Failed to find or load tarot_deck.json")
        }
        
        do {
            // Decode the JSON structure with a root "cards" array
            let decoder = JSONDecoder()
            let container = try decoder.decode(CardContainer.self, from: data)
            return container.cards
        } catch {
            print("Error decoding tarot deck: \(error)")
            fatalError("Failed to decode tarot deck")
        }
    }
    
    func shuffleAndDraw(_ count: Int) -> [Card] {
        var shuffledDeck = loadDeck().shuffled()
        var drawnCards: [Card] = []
        
        for _ in 0..<count {
            guard let card = shuffledDeck.popLast() else { break }
            // Randomly determine if card is reversed
            let isReversed = Bool.random()
            let drawnCard = Card(
                id: card.id,
                name: card.name,
                description: card.description,
                imageUrl: card.imageUrl,
                keywords: card.keywords,
                isReversed: isReversed
            )
            drawnCards.append(drawnCard)
        }
        
        return drawnCards
    }
}

// Container struct to match JSON structure
struct CardContainer: Codable {
    let cards: [Card]
} 