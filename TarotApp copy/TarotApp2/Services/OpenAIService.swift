import Foundation

protocol AIService {
    func classifyIntent(_ question: String) async throws -> SpreadType
    func generateReading(cards: [Card], spreadType: SpreadType) async throws -> Reading
}

class OpenAIService: AIService {
    private let apiKey = "your API key"
    private let baseURL = "you API url"
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2.0
    
    func classifyIntent(_ question: String) async throws -> SpreadType {
        let prompt = """
        As a Tarot expert, analyze this question and classify it into one of these spread types:
        - general (for overall life situations)
        - love (for relationships and emotions)
        - career (for work and professional life)
        - study (for education and learning)
        - daily (for day-to-day guidance)
        - decision (for help with choices)

        Question: "\(question)"

        Respond with only one word from the above options that best matches the question's intent.
        """
        
        let response = try await sendRequestWithRetry(prompt: prompt)
        let spreadTypeString = response.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard let spreadType = SpreadType(rawValue: spreadTypeString) else {
            throw AppError.invalidSpreadType
        }
        
        return spreadType
    }
    
    func generateReading(cards: [Card], spreadType: SpreadType) async throws -> Reading {
        let cardsDescription = cards.enumerated().map { index, card in
            """
            Card \(index + 1) - \(card.name) (\(card.isReversed ? "reversed" : "upright"))
            Position: \(Card.getPositionMeaning(position: index, spreadType: spreadType))
            Keywords: \(card.keywordsDisplay)
            """
        }.joined(separator: "\n\n")
        
        let prompt = """
        As an experienced Tarot reader, provide a detailed reading for a \(spreadType.title) spread.

        Cards in position:
        \(cardsDescription)

        Please provide:
        1. Individual Card Interpretations: Analyze each card in its position, considering its orientation (upright/reversed).
        2. Combined Reading: How do these cards interact and what story do they tell together?
        3. Advice: Based on this reading, what guidance would you give the querent?

        Format the response with clear sections using these exact headings:
        "Individual Meanings"
        "Combined Interpretation"
        "Concluding Advice"
        """
        
        let response = try await sendRequestWithRetry(prompt: prompt)
        return Reading(text: response, cards: cards, spreadType: spreadType)
    }
    
    private func sendRequestWithRetry(prompt: String, retryCount: Int = 0) async throws -> String {
        do {
            return try await sendRequest(prompt: prompt)
        } catch {
            if retryCount < maxRetries {
                // Wait before retrying
                try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                return try await sendRequestWithRetry(prompt: prompt, retryCount: retryCount + 1)
            } else {
                throw AppError.openAIError("Failed after \(maxRetries) retries: \(error.localizedDescription)")
            }
        }
    }
    
    private func sendRequest(prompt: String) async throws -> String {
        let message = ["role": "user", "content": prompt]
        let body: [String: Any] = [
            "model": "gpt-4",
            "messages": [message],
            "temperature": 0.7,
            "max_tokens": 2000
        ]
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AppError.networkError("Invalid response")
        }
        
        // Handle specific HTTP status codes
        switch httpResponse.statusCode {
        case 200:
            let apiResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            return apiResponse.choices.first?.message.content ?? ""
        case 429:
            throw AppError.openAIError("Rate limit exceeded")
        case 500, 502, 503, 504:
            throw AppError.openAIError("Server error: \(httpResponse.statusCode)")
        default:
            throw AppError.openAIError("API Error: \(httpResponse.statusCode)")
        }
    }
}

// OpenAI API response models
struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
} 
