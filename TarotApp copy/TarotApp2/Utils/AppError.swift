import Foundation

enum AppError: LocalizedError {
    case openAIError(String)
    case networkError(String)
    case invalidData
    case deckLoadError
    case invalidSpreadType
    case missingAPIKey
    
    var errorDescription: String? {
        switch self {
        case .openAIError(let message):
            return "OpenAI Error: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        case .invalidData:
            return "Invalid data received"
        case .deckLoadError:
            return "Failed to load tarot deck"
        case .invalidSpreadType:
            return "Invalid spread type"
        case .missingAPIKey:
            return "OpenAI API key not found"
        }
    }
}

// Error handling utility
struct ErrorHandler {
    static func handle(_ error: Error) -> String {
        if let appError = error as? AppError {
            return appError.errorDescription ?? "Unknown error occurred"
        }
        return error.localizedDescription
    }
} 