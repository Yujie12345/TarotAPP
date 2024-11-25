import Foundation

@MainActor
class AskQuestionViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var showReading = false
    @Published var selectedSpread: SpreadType?
    
    private let aiService: AIService
    
    init(aiService: AIService = OpenAIService()) {
        self.aiService = aiService
    }
    
    func processQuestion(_ question: String) async {
        guard !question.isEmpty else {
            showError(message: "Please enter a question")
            return
        }
        
        isLoading = true
        
        do {
            let spreadType = try await aiService.classifyIntent(question)
            selectedSpread = spreadType
            showReading = true
        } catch {
            showError(message: error.localizedDescription)
        }
        
        isLoading = false
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
} 