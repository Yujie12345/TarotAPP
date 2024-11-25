import SwiftUI

struct AskQuestionView: View {
    @StateObject private var viewModel = AskQuestionViewModel()
    @State private var question: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color.lightYellow
                .ignoresSafeArea()
            
            // Content
            ScrollView {
                VStack(spacing: 32) {
                    // Title and guidance
                    VStack(spacing: 16) {
                        Text("🔮 Tarot Reading")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Text("What do you want to ask today?")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // Question input
                    VStack(spacing: 16) {
                        // Clue buttons above text field
                        HStack(spacing: 8) {
                            ForEach(SpreadType.allCases.prefix(3), id: \.self) { type in
                                ClueButton(text: type.rawValue) {
                                    question = "I need guidance about \(type.rawValue)"
                                }
                            }
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(SpreadType.allCases.suffix(3), id: \.self) { type in
                                ClueButton(text: type.rawValue) {
                                    question = "I need guidance about \(type.rawValue)"
                                }
                            }
                        }
                        
                        TextField("Enter your question...", text: $question)
                            .textFieldStyle(CustomTextFieldStyle())
                            .padding(.horizontal)
                            .focused($isTextFieldFocused)
                        
                        Button(action: {
                            isTextFieldFocused = false
                            Task {
                                await viewModel.processQuestion(question)
                            }
                        }) {
                            Text("Ask the Cards")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(
                                    question.isEmpty ? Color.gray.opacity(0.5) : Color.DarkViolet
                                )
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 5)
                        }
                        .disabled(question.isEmpty)
                        .padding(.horizontal)
                    }
                    
                    // Spread type suggestions
                    VStack(spacing: 16) {
                        Text("Or choose a spread type:")
                            .font(.headline)
                            .foregroundColor(.gray.opacity(0.9))
                        
                        ForEach(SpreadType.allCases, id: \.self) { spreadType in
                            Button(action: {
                                question = "I would like a \(spreadType.rawValue) reading"
                                isTextFieldFocused = false
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(spreadType.title)
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                        
                                        Text(getSpreadDescription(spreadType))
                                            .font(.caption)
                                            .foregroundColor(.gray.opacity(0.8))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                                .padding()
                                .background(Color.lightYellow.opacity(0.3))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .onTapGesture {
                isTextFieldFocused = false
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .fullScreenCover(isPresented: $viewModel.showReading) {
            ReadingView(spread: viewModel.selectedSpread)
        }
    }
    
    private func getSpreadDescription(_ type: SpreadType) -> String {
        switch type {
        case .general: return "For overall life guidance (10 cards)"
        case .love: return "For relationships and emotions (7 cards)"
        case .career: return "For work and professional life (6 cards)"
        case .study: return "For education and learning (7 cards)"
        case .daily: return "For day-to-day guidance (3 cards)"
        case .decision: return "For help with choices (7 cards)"
        }
    }
}

// Clue Button
struct ClueButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(15)
        }
    }
}

// Custom text field style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(15)
            .foregroundColor(.black)
            .accentColor(.lightYellow)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

// Preview
struct AskQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AskQuestionView()
    }
} 
