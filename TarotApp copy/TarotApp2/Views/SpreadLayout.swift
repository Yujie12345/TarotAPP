import SwiftUI

struct SpreadLayout: View {
    let cards: [Card]
    let spreadType: SpreadType?
    
    var body: some View {
        Group {
            switch spreadType {
            case .general:
                if cards.count >= 10 {
                    CelticCrossLayout(cards: cards)
                }
            case .love:
                if cards.count >= 7 {
                    ColumnLayout(cards: cards)
                }
            case .career:
                if cards.count >= 6 {
                    PyramidLayout(cards: cards)
                }
            case .daily:
                if cards.count >= 3 {
                    HorizontalLayout(cards: cards)
                }
            case .study:
                if cards.count >= 7 {
                    HorseShoeLayout(cards: cards)
                }
            case .decision:
                if cards.count >= 7 {
                    DecisionLayout(cards: cards)
                }
            case .none:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: cards)
    }
}

// We'll implement each layout type next. Would you like me to continue with those? 