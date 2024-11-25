enum SpreadType: String, CaseIterable {
    case general = "general"
    case love = "love"
    case career = "career"
    case study = "study"
    case daily = "daily"
    case decision = "decision"
    
    var title: String {
        switch self {
        case .general: return "General Reading"
        case .love: return "Love Reading"
        case .career: return "Career Reading"
        case .study: return "Study Reading"
        case .daily: return "Daily Reading"
        case .decision: return "Decision Reading"
        }
    }
} 