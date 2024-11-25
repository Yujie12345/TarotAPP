import SwiftUI

struct ReadingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ReadingViewModel
    @State private var showingCards = false
    
    init(spread: SpreadType?) {
        _viewModel = StateObject(wrappedValue: ReadingViewModel(spreadType: spread))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.lightYellow
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header with back button
                    HStack {
                        Button(action: { dismiss() }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    // Spread title
                    Text(viewModel.spreadType?.title ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    
                    // Cards layout with animation
                    SpreadLayout(cards: viewModel.cards, spreadType: viewModel.spreadType)
                        .opacity(showingCards ? 1 : 0)
                        .animation(.easeIn(duration: 0.5).delay(0.3), value: showingCards)
                    
                    // Reading text
                    if let reading = viewModel.reading {
                        ReadingTextView(reading: reading)
                            .transition(.opacity)
                            .animation(.easeIn(duration: 0.5).delay(0.8), value: reading)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            
            // Loading overlay
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
        .task {
            await viewModel.generateReading()
            withAnimation {
                showingCards = true
            }
        }
        .accentColor(.purple)
    }
}

struct ReadingTextView: View {
    let reading: Reading
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Individual card meanings
            VStack(alignment: .leading, spacing: 16) {
                Text("Card Meanings")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                Text(reading.individualMeanings)
                    .foregroundColor(.gray.opacity(0.9))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            
            // Combined interpretation
            VStack(alignment: .leading, spacing: 16) {
                Text("Combined Interpretation")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                Text(reading.combinedInterpretation)
                    .foregroundColor(.gray.opacity(0.9))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            
            // Advice
            VStack(alignment: .leading, spacing: 16) {
                Text("Advice")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                Text(reading.advice)
                    .foregroundColor(.gray.opacity(0.9))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
        }
    }
} 