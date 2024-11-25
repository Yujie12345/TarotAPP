import Foundation

struct Reading: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let cards: [Card]
    let spreadType: SpreadType
    
    // Computed properties to split the reading text into sections
    var individualMeanings: String {
        var meanings = ""
        
        // Add position meanings and card names based on spread type
        for (index, card) in cards.enumerated() {
            let position = getPositionMeaning(index: index)
            meanings += "\n\(position):\n"
            meanings += "Card: \(card.name)\n"
            meanings += card.getMeaning(isReversed: card.isReversed)
            meanings += "\n"
        }
        
        return meanings.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var combinedInterpretation: String {
        if let range = text.range(of: "Combined Interpretation")?.upperBound,
           let endRange = text.range(of: "Concluding Advice")?.lowerBound {
            return String(text[range..<endRange]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
    
    var advice: String {
        if let range = text.range(of: "Concluding Advice")?.upperBound {
            return String(text[range...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
    
    private func getPositionMeaning(index: Int) -> String {
        switch spreadType {
        case .daily:
            let positions = ["Past", "Present", "Future"]
            return positions[index]
        case .love:
            let positions = ["Other's Persona", "Your Persona", "Connection", 
                           "Common Base", "What They Offer", "What You Offer", "Mutual Goals"]
            return positions[index]
        case .career:
            let positions = ["Current Situation", "Challenges", "Opportunities",
                           "Action", "Environment", "Outcome"]
            return positions[index]
        case .study:
            let positions = ["Past Studies", "Current Challenges", "Present Situation",
                           "Near Future", "Study Environment", "Guidance", "Final Outcome"]
            return positions[index]
        case .decision:
            let positions = ["If You Do: Immediate Outcome", "If You Do: Long-term Impact",
                           "If You Do: Hidden Influence", "Key Factor",
                           "If You Don't: Immediate Outcome", "If You Don't: Long-term Impact",
                           "If You Don't: Hidden Influence"]
            return positions[index]
        case .general:
            let positions = ["Present Situation", "Challenge/Crossing", "Crown (Conscious)",
                           "Foundation (Unconscious)", "Past", "Future", "Self",
                           "Environment", "Hopes/Fears", "Final Outcome"]
            return positions[index]
        }
    }
    
    static func == (lhs: Reading, rhs: Reading) -> Bool {
        lhs.id == rhs.id
    }
} 