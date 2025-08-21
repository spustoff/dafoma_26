//
//  QuizResultView.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

struct QuizResultView: View {
    let quiz: Quiz
    let result: QuizResult
    let detailedResults: QuizDetailedResults
    let onFinish: () -> Void
    let retakeAction: () -> Void
    
    @State private var animateScore = false
    @State private var showConfetti = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    // Performance Icon
                    Image(systemName: getPerformanceIcon())
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(getScoreColor())
                        .scaleEffect(animateScore ? 1.0 : 0.5)
                        .opacity(animateScore ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: animateScore)
                    
                    Text(getPerformanceTitle())
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .opacity(animateScore ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.5), value: animateScore)
                    
                    Text(quiz.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .opacity(animateScore ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.7), value: animateScore)
                }
                .padding(.top, 40)
                
                // Score Circle
                ZStack {
                    Circle()
                        .stroke(Color.backgroundTertiary, lineWidth: 12)
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .trim(from: 0, to: animateScore ? result.percentage / 100 : 0)
                        .stroke(getScoreColor(), lineWidth: 12)
                        .frame(width: 160, height: 160)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 2.0).delay(0.8), value: animateScore)
                    
                    VStack(spacing: 8) {
                        Text("\(Int(result.percentage))%")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .opacity(animateScore ? 1.0 : 0.0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.2), value: animateScore)
                        
                        Text("\(result.score) / \(result.totalQuestions)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textSecondary)
                            .opacity(animateScore ? 1.0 : 0.0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.4), value: animateScore)
                    }
                }
                
                // Stats Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ResultStatCard(
                        title: "Time Taken",
                        value: result.timeTaken.formattedTime,
                        icon: "clock.fill",
                        color: .primaryBlue
                    )
                    
                    ResultStatCard(
                        title: "Avg per Question",
                        value: detailedResults.timePerQuestion.formattedTime,
                        icon: "speedometer",
                        color: .primaryGreen
                    )
                    
                    ResultStatCard(
                        title: "Correct Answers",
                        value: "\(result.score)",
                        icon: "checkmark.circle.fill",
                        color: .successGreen
                    )
                    
                    ResultStatCard(
                        title: "Accuracy",
                        value: "\(Int(result.percentage))%",
                        icon: "target",
                        color: getScoreColor()
                    )
                }
                .padding(.horizontal, 20)
                .opacity(animateScore ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.6), value: animateScore)
                
                // Performance Message
                PerformanceMessageView(percentage: result.percentage)
                    .padding(.horizontal, 20)
                    .opacity(animateScore ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.8), value: animateScore)
                
                // Question Results
                QuestionResultsSection(detailedResults: detailedResults)
                    .padding(.horizontal, 20)
                    .opacity(animateScore ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(2.0), value: animateScore)
                
                // Action Buttons
                VStack(spacing: 16) {
                    Button(action: onFinish) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryGradient)
                            .cornerRadius(12)
                            .shadow(color: Color.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Button(action: retakeAction) {
                        Text("Retake Quiz")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.backgroundSecondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.primaryBlue, lineWidth: 2)
                            )
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .opacity(animateScore ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(2.2), value: animateScore)
            }
        }
        .navigationTitle("Quiz Results")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            animateScore = true
            if result.percentage >= 90 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showConfetti = true
                }
            }
        }
        .overlay(
            ConfettiView(isActive: showConfetti)
                .allowsHitTesting(false)
        )
    }
    
    private func getScoreColor() -> Color {
        switch result.percentage {
        case 90...100: return .successGreen
        case 70..<90: return .primaryBlue
        case 50..<70: return .warningYellow
        default: return .errorRed
        }
    }
    
    private func getPerformanceIcon() -> String {
        switch result.percentage {
        case 90...100: return "star.fill"
        case 70..<90: return "thumbsup.fill"
        case 50..<70: return "hand.thumbsup"
        default: return "arrow.up"
        }
    }
    
    private func getPerformanceTitle() -> String {
        switch result.percentage {
        case 90...100: return "Excellent!"
        case 70..<90: return "Great Job!"
        case 50..<70: return "Good Effort!"
        default: return "Keep Learning!"
        }
    }
}

struct ResultStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.backgroundSecondary)
        .cornerRadius(16)
    }
}

struct PerformanceMessageView: View {
    let percentage: Double
    
    private var message: String {
        switch percentage {
        case 90...100:
            return "Outstanding performance! You've mastered this topic. Keep up the excellent work!"
        case 70..<90:
            return "Great job! You have a solid understanding of the material. A few more practice sessions and you'll be perfect!"
        case 50..<70:
            return "Good effort! You're on the right track. Review the explanations and try again to improve your score."
        default:
            return "Don't give up! Learning takes time. Review the material and try again. You'll get better with practice!"
        }
    }
    
    private var backgroundColor: Color {
        switch percentage {
        case 90...100: return .successGreen.opacity(0.1)
        case 70..<90: return .primaryBlue.opacity(0.1)
        case 50..<70: return .warningYellow.opacity(0.1)
        default: return .errorRed.opacity(0.1)
        }
    }
    
    private var borderColor: Color {
        switch percentage {
        case 90...100: return .successGreen
        case 70..<90: return .primaryBlue
        case 50..<70: return .warningYellow
        default: return .errorRed
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Performance Feedback")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text(message)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .padding(20)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

struct QuestionResultsSection: View {
    let detailedResults: QuizDetailedResults
    @State private var expandedQuestions: Set<UUID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Question Results")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(Array(detailedResults.questionResults.enumerated()), id: \.element.question.id) { index, questionResult in
                    QuestionResultCard(
                        questionResult: questionResult,
                        questionNumber: index + 1,
                        isExpanded: expandedQuestions.contains(questionResult.question.id)
                    ) {
                        if expandedQuestions.contains(questionResult.question.id) {
                            expandedQuestions.remove(questionResult.question.id)
                        } else {
                            expandedQuestions.insert(questionResult.question.id)
                        }
                    }
                }
            }
        }
    }
}

struct QuestionResultCard: View {
    let questionResult: QuestionResult
    let questionNumber: Int
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    // Result indicator
                    Image(systemName: questionResult.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(questionResult.isCorrect ? .successGreen : .errorRed)
                    
                    // Question number and preview
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Question \(questionNumber)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(questionResult.isCorrect ? .successGreen : .errorRed)
                        
                        Text(questionResult.question.text.prefix(50) + (questionResult.question.text.count > 50 ? "..." : ""))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Expand/collapse icon
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textTertiary)
                }
                .padding(16)
            }
            .background(questionResult.isCorrect ? Color.successGreen.opacity(0.05) : Color.errorRed.opacity(0.05))
            
            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Full question
                    Text(questionResult.question.text)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    // Answer options
                    VStack(spacing: 8) {
                        ForEach(Array(questionResult.question.options.enumerated()), id: \.offset) { index, option in
                            QuestionResultOption(
                                text: option,
                                index: index,
                                isCorrect: index == questionResult.question.correctAnswerIndex,
                                isSelected: index == questionResult.selectedAnswerIndex
                            )
                        }
                    }
                    
                    // Explanation (if available)
                    if let explanation = questionResult.question.explanation {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.warningYellow)
                                
                                Text("Explanation")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                            }
                            
                            Text(explanation)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(12)
                        .background(Color.backgroundTertiary)
                        .cornerRadius(8)
                    }
                }
                .padding(16)
                .background(Color.backgroundSecondary)
            }
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(questionResult.isCorrect ? Color.successGreen.opacity(0.3) : Color.errorRed.opacity(0.3), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
}

struct QuestionResultOption: View {
    let text: String
    let index: Int
    let isCorrect: Bool
    let isSelected: Bool
    
    private var backgroundColor: Color {
        if isCorrect {
            return .successGreen.opacity(0.1)
        } else if isSelected {
            return .errorRed.opacity(0.1)
        } else {
            return .backgroundTertiary
        }
    }
    
    private var textColor: Color {
        if isCorrect {
            return .successGreen
        } else if isSelected {
            return .errorRed
        } else {
            return .textSecondary
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Option letter
            Text(String(UnicodeScalar(65 + index)!))
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(textColor)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(backgroundColor)
                )
            
            // Option text
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Status icon
            if isCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.successGreen)
            } else if isSelected {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.errorRed)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(backgroundColor)
        .cornerRadius(8)
    }
}

struct ConfettiView: View {
    let isActive: Bool
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece()
                    .opacity(isActive ? 1 : 0)
                    .scaleEffect(isActive ? 1 : 0)
                    .animation(.easeOut(duration: 3).delay(Double(index) * 0.02), value: isActive)
            }
        }
    }
}

struct ConfettiPiece: View {
    @State private var location = CGPoint(x: 0, y: 0)
    @State private var opacity = 1.0
    
    var body: some View {
        Rectangle()
            .fill([Color.primaryBlue, Color.successGreen, Color.warningYellow, Color.primaryPurple, Color.orange].randomElement() ?? Color.blue)
            .frame(width: 8, height: 8)
            .position(location)
            .opacity(opacity)
            .onAppear {
                location = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -10
                )
                
                withAnimation(.easeOut(duration: 3)) {
                    location = CGPoint(
                        x: location.x + CGFloat.random(in: -100...100),
                        y: UIScreen.main.bounds.height + 10
                    )
                    opacity = 0
                }
            }
    }
}

#Preview("Quiz Result - Excellent") {
    QuizResultView(
        quiz: Quiz(
            title: "Strategic Planning Fundamentals",
            category: .businessStrategy,
            description: "Test your knowledge of strategic planning",
            difficulty: .beginner,
            estimatedTime: 8,
            questions: []
        ),
        result: QuizResult(
            quizId: UUID(),
            quizTitle: "Strategic Planning Fundamentals",
            score: 5,
            totalQuestions: 5,
            timeTaken: 480
        ),
        detailedResults: QuizDetailedResults(
            quizResult: QuizResult(
                quizId: UUID(),
                quizTitle: "Strategic Planning Fundamentals",
                score: 5,
                totalQuestions: 5,
                timeTaken: 480
            ),
            questionResults: [],
            timePerQuestion: 96
        ),
        onFinish: {},
        retakeAction: {}
    )
}
