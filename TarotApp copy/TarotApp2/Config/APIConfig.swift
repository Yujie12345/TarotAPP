import Foundation

enum APIConfig {
    static var openAIKey: String {
        guard let key = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? 
              Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("OpenAI API key not found. Please add it to environment variables or Info.plist")
        }
        return key
    }
} 