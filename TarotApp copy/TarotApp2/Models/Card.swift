import Foundation

struct Card: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
    let keywords: [String]
    var isReversed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl
        case keywords
    }
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        keywords = try container.decode([String].self, forKey: .keywords)
        isReversed = false  // Default value, will be set randomly when drawing cards
    }
    
    // Manual initializer for creating cards
    init(id: Int, name: String, description: String, imageUrl: String, keywords: [String], isReversed: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
        self.keywords = keywords
        self.isReversed = isReversed
    }
    
    // Helper computed properties
    var isMajorArcana: Bool {
        return id <= 21
    }
    
    var fullImageName: String {
        if isMajorArcana {
            // Major arcana: convert to lowercase and remove any file extension
            let cleanName = imageUrl
                .replacingOccurrences(of: "major/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
                .replacingOccurrences(of: ".png", with: "")
                .lowercased()
            return "\(cleanName)"
        } else {
            // Convert minor arcana paths
            // From: minor/wands_ace, minor/wands_2, etc.
            // To: cards/minor/wands-1.imageset, etc.
            let components = imageUrl.replacingOccurrences(of: "minor/", with: "").split(separator: "_")
            if components.count == 2 {
                let suit = components[0]  // wands, cups, etc.
                let rank = components[1]  // ace, 2, 3, etc.
                
                // Convert rank to number
                let number: String
                switch rank {
                case "ace": number = "1"
                case "page": number = "11"
                case "knight": number = "12"
                case "queen": number = "13"
                case "king": number = "14"
                default: number = String(rank)
                }
                
                let imageName = "\(suit)-\(number)"
                return "\(imageName)"
            }
            return "\(imageUrl)"  // fallback
        }
    }
    
    var keywordsDisplay: String {
        keywords.joined(separator: ", ")
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id && lhs.isReversed == rhs.isReversed
    }
}

// Extension for card-specific functionality
extension Card {
    func getMeaning(isReversed: Bool) -> String {
        if isReversed {
            return "Reversed: \(description) (in its challenging aspect)"
        }
        return description
    }
    
    static func getPositionMeaning(position: Int, spreadType: SpreadType) -> String {
        switch spreadType {
        case .daily:
            let positions = ["Past", "Present", "Future"]
            return positions[position]
        case .love:
            let positions = ["Past Love", "Current Feelings", "Partner's Feelings", 
                           "Obstacles", "External Influences", "Advice", "Outcome"]
            return positions[position]
        default:
            return "Position \(position + 1)"
        }
    }
} 
