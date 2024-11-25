import Foundation

class ReadingViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var reading: Reading?
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    let spreadType: SpreadType?
    private let aiService: AIService
    
    init(spreadType: SpreadType?) {
        self.spreadType = spreadType
        self.aiService = OpenAIService()
    }
    
    func generateReading() async {
        guard let spreadType = spreadType else { return }
        
        await MainActor.run {
            isLoading = true
        }
        
        do {
            // Draw cards using shared instance
            let drawnCards = DeckService.shared.shuffleAndDraw(getCardCount(for: spreadType))
            
            await MainActor.run {
                self.cards = drawnCards
            }
            
            let reading = try await aiService.generateReading(cards: drawnCards, spreadType: spreadType)
            
            await MainActor.run {
                self.reading = reading
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = ErrorHandler.handle(error)
                self.showError = true
                self.isLoading = false
            }
        }
    }
    
    private func getCardCount(for spreadType: SpreadType) -> Int {
        switch spreadType {
        case .general: return 10  // Celtic Cross
        case .love: return 7     // Column
        case .career: return 6   // Pyramid
        case .daily: return 3    // Horizontal
        case .study: return 7    // Horseshoe
        case .decision: return 7 // Decision
        }
    }
} 