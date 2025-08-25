//
//  QuizDetailView.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

struct QuizDetailView: View {
    let quiz: Quiz
    @EnvironmentObject private var userDataService: UserDataService
    @StateObject private var quizViewModel = QuizViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingQuizView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    QuizHeaderView(quiz: quiz)
                    
                    // Quiz Info
                    QuizInfoSection(quiz: quiz)
                    
                    // Previous Results (if any)
                    if let bestResult = userDataService.getBestScore(for: quiz.id) {
                        PreviousResultsSection(result: bestResult)
                    }
                    
                    // Questions Preview
                    QuestionsPreviewSection(questions: Array(quiz.questions.prefix(3)))
                    
                    // Start Button
                    VStack(spacing: 16) {
                        Button(action: {
                            showingQuizView = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Text(userDataService.hasCompletedQuiz(withId: quiz.id) ? "Retake Quiz" : "Start Quiz")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryGradient)
                            .cornerRadius(12)
                            .shadow(color: Color.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        if userDataService.hasCompletedQuiz(withId: quiz.id) {
                            Text("You've already completed this quiz. Your best score will be saved.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Quiz Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                }
            )
        }
        .fullScreenCover(isPresented: $showingQuizView) {
            QuizPlayView(quiz: quiz)
                .environmentObject(userDataService)
        }
    }
}

struct QuizHeaderView: View {
    let quiz: Quiz
    
    var body: some View {
        VStack(spacing: 16) {
            // Category and difficulty badges
            HStack {
                CategoryBadge(category: quiz.category)
                Spacer()
                DifficultyBadge(difficulty: quiz.difficulty)
            }
            .padding(.horizontal, 20)
            
            // Title
            Text(quiz.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Description
            Text(quiz.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
}

struct QuizInfoSection: View {
    let quiz: Quiz
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quiz Information")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                QuizInfoRow(
                    icon: "questionmark.circle.fill",
                    title: "Questions",
                    value: "\(quiz.questions.count)",
                    color: .primaryBlue
                )
                
                QuizInfoRow(
                    icon: "clock.fill",
                    title: "Estimated Time",
                    value: "\(quiz.estimatedTime) minutes",
                    color: .primaryGreen
                )
                
                QuizInfoRow(
                    icon: "chart.bar.fill",
                    title: "Difficulty",
                    value: quiz.difficulty.rawValue,
                    color: Color.difficultyColor(for: quiz.difficulty)
                )
                
                QuizInfoRow(
                    icon: "building.2.fill",
                    title: "Business Focused",
                    value: quiz.isBusinessFocused ? "Yes" : "No",
                    color: quiz.isBusinessFocused ? .successGreen : .textSecondary
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuizInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textSecondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

struct PreviousResultsSection: View {
    let result: QuizResult
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Your Best Score")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                // Score circle
                ZStack {
                    Circle()
                        .stroke(Color.backgroundTertiary, lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: result.percentage / 100)
                        .stroke(getScoreColor(result.percentage), lineWidth: 8)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.5), value: result.percentage)
                    
                    VStack(spacing: 4) {
                        Text("\(Int(result.percentage))%")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("\(result.score)/\(result.totalQuestions)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                }
                
                // Result details
                VStack(spacing: 8) {
                    Text("Completed on \(result.completionDate.formatted(style: .medium))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    Text("Time taken: \(result.timeTaken.formattedTime)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(Color.backgroundSecondary)
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
    
    private func getScoreColor(_ percentage: Double) -> Color {
        switch percentage {
        case 90...100: return .successGreen
        case 70..<90: return .primaryBlue
        case 50..<70: return .warningYellow
        default: return .errorRed
        }
    }
}

struct QuestionsPreviewSection: View {
    let questions: [Question]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Sample Questions")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                ForEach(Array(questions.enumerated()), id: \.element.id) { index, question in
                    QuestionPreviewCard(question: question, index: index + 1)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct QuestionPreviewCard: View {
    let question: Question
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Question \(index)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primaryBlue)
                
                Spacer()
            }
            
            Text(question.text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.leading)
            
            Text("\(question.options.count) answer options")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .padding(16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

struct QuizPlayView: View {
    let quiz: Quiz
    @EnvironmentObject private var userDataService: UserDataService
    @StateObject private var quizViewModel = QuizViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingExitAlert = false
    
    var body: some View {
        NavigationView {
            Group {
                if quizViewModel.isQuizCompleted {
                    QuizResultView(
                        quiz: quiz,
                        result: quizViewModel.quizResult!,
                        detailedResults: quizViewModel.getDetailedResults()!
                    ) {
                        // Save result and dismiss
                        if let result = quizViewModel.quizResult {
                            userDataService.addQuizResult(result)
                        }
                        dismiss()
                    } retakeAction: {
                        // Restart quiz
                        quizViewModel.startQuiz(with: quiz)
                    }
                } else {
                    QuizQuestionView()
                        .environmentObject(quizViewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button("Exit") {
                    showingExitAlert = true
                }
                .foregroundColor(.errorRed),
                
                trailing: !quizViewModel.isQuizCompleted ? 
                    AnyView(
                        Text("\(quizViewModel.timeRemaining.formattedTime)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(quizViewModel.timeRemaining < 60 ? .errorRed : .textSecondary)
                    ) : AnyView(EmptyView())
            )
        }
        .onAppear {
            quizViewModel.startQuiz(with: quiz)
        }
        .alert("Exit Quiz", isPresented: $showingExitAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Exit", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("Are you sure you want to exit? Your progress will be lost.")
        }
    }
}

struct QuizQuestionView: View {
    @EnvironmentObject private var quizViewModel: QuizViewModel
    @State private var selectedAnswer: Int?
    @State private var animateOptions = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            VStack {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 4)
                            .opacity(0.3)
                            .foregroundColor(.gray)
                        
                        Rectangle()
                            .frame(width: min(CGFloat(quizViewModel.getProgress()) * geometry.size.width, geometry.size.width), height: 4)
                            .foregroundColor(.primaryBlue)
                            .animation(.linear, value: quizViewModel.getProgress())
                    }
                    .cornerRadius(2)
                }
                .frame(height: 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 24) {
                    // Question Header
                    VStack(spacing: 16) {
                        HStack {
                            Text("Question \(quizViewModel.currentQuestionIndex + 1)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryBlue)
                            
                            Spacer()
                            
                            Text("\(quizViewModel.currentQuestionIndex + 1) of \(quizViewModel.currentQuiz?.questions.count ?? 0)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        
                        if let question = quizViewModel.getCurrentQuestion() {
                            Text(question.text)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Answer Options
                    if let question = quizViewModel.getCurrentQuestion() {
                        VStack(spacing: 12) {
                            ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                                AnswerOptionButton(
                                    text: option,
                                    index: index,
                                    isSelected: selectedAnswer == index,
                                    showResult: quizViewModel.showExplanation,
                                    isCorrect: index == question.correctAnswerIndex
                                ) {
                                    selectedAnswer = index
                                    quizViewModel.selectAnswer(for: question.id, answerIndex: index)
                                }
                                .opacity(animateOptions ? 1 : 0)
                                .offset(y: animateOptions ? 0 : 20)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateOptions)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Explanation (if shown)
                    if quizViewModel.showExplanation,
                       let question = quizViewModel.getCurrentQuestion(),
                       let explanation = question.explanation {
                        ExplanationView(explanation: explanation)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // Bottom Actions
            VStack(spacing: 16) {
                if quizViewModel.showExplanation {
                    Button(action: {
                        quizViewModel.nextQuestion()
                        selectedAnswer = nil
                        animateOptions = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateOptions = true
                        }
                    }) {
                        Text(quizViewModel.currentQuestionIndex == (quizViewModel.currentQuiz?.questions.count ?? 0) - 1 ? "Finish Quiz" : "Next Question")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryGradient)
                            .cornerRadius(12)
                    }
                } else {
                    HStack(spacing: 16) {
                        if quizViewModel.canProceedToNext() {
                            Button("Show Answer") {
                                quizViewModel.toggleExplanation()
                            }
                            .secondaryButtonStyle()
                        }
                        
                        Button(quizViewModel.canProceedToNext() ? "Next" : "Skip") {
                            if quizViewModel.canProceedToNext() {
                                quizViewModel.nextQuestion()
                            } else {
                                quizViewModel.nextQuestion()
                            }
                            selectedAnswer = nil
                            animateOptions = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                animateOptions = true
                            }
                        }
                        .primaryButtonStyle()
                        .opacity(quizViewModel.canProceedToNext() ? 1.0 : 0.7)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .background(Color.backgroundPrimary)
        }
        .onAppear {
            selectedAnswer = quizViewModel.getCurrentQuestion().flatMap { question in
                quizViewModel.getSelectedAnswer(for: question.id)
            }
            animateOptions = true
        }
    }
}

struct AnswerOptionButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let showResult: Bool
    let isCorrect: Bool
    let onTap: () -> Void
    
    private var backgroundColor: Color {
        if showResult {
            if isCorrect {
                return .successGreen.opacity(0.2)
            } else if isSelected {
                return .errorRed.opacity(0.2)
            } else {
                return .backgroundSecondary
            }
        } else if isSelected {
            return .primaryBlue.opacity(0.1)
        } else {
            return .backgroundSecondary
        }
    }
    
    private var borderColor: Color {
        if showResult {
            if isCorrect {
                return .successGreen
            } else if isSelected {
                return .errorRed
            } else {
                return .clear
            }
        } else if isSelected {
            return .primaryBlue
        } else {
            return .clear
        }
    }
    
    private var iconName: String? {
        if showResult {
            if isCorrect {
                return "checkmark.circle.fill"
            } else if isSelected {
                return "xmark.circle.fill"
            }
        }
        return nil
    }
    
    var body: some View {
        Button(action: showResult ? {} : onTap) {
            HStack(spacing: 16) {
                // Option letter
                Text(String(UnicodeScalar(65 + index)!))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(showResult && isCorrect ? .successGreen : (isSelected ? .primaryBlue : .textSecondary))
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(showResult && isCorrect ? Color.successGreen.opacity(0.2) : (isSelected ? Color.primaryBlue.opacity(0.2) : Color.backgroundTertiary))
                    )
                
                // Option text
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Result icon
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isCorrect ? .successGreen : .errorRed)
                }
            }
            .padding(16)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
            .contentShape(Rectangle())
        }
        .buttonStyle(ResponsiveButtonStyle())
        .disabled(showResult)
        .scaleEffect(isSelected && !showResult ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct ExplanationView: View {
    let explanation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.warningYellow)
                
                Text("Explanation")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
            }
            
            Text(explanation)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

#Preview("Quiz Detail") {
    QuizDetailView(
        quiz: Quiz(
            title: "Strategic Planning Fundamentals",
            category: .businessStrategy,
            description: "Test your knowledge of core strategic planning principles and frameworks used by successful companies.",
            difficulty: .beginner,
            estimatedTime: 8,
            questions: [
                Question(
                    text: "What is the primary purpose of a SWOT analysis?",
                    options: ["To analyze financial performance", "To identify Strengths, Weaknesses, Opportunities, and Threats", "To create marketing campaigns", "To manage employee performance"],
                    correctAnswerIndex: 1,
                    explanation: "SWOT analysis helps organizations understand their internal strengths and weaknesses while identifying external opportunities and threats."
                )
            ]
        )
    )
    .environmentObject(UserDataService())
}
