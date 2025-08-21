//
//  QuizViewModel.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation

class QuizViewModel: ObservableObject {
    @Published var currentQuiz: Quiz?
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [UUID: Int] = [:]
    @Published var isQuizCompleted: Bool = false
    @Published var timeRemaining: TimeInterval = 0
    @Published var quizStartTime: Date?
    @Published var showExplanation: Bool = false
    @Published var quizResult: QuizResult?
    
    private var timer: Timer?
    private let quizService = QuizService()
    
    init() {}
    
    func startQuiz(with quiz: Quiz) {
        currentQuiz = quiz
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        isQuizCompleted = false
        quizStartTime = Date()
        showExplanation = false
        quizResult = nil
        
        // Set timer for the quiz (estimated time in minutes * 60)
        timeRemaining = TimeInterval(quiz.estimatedTime * 60)
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.completeQuiz()
            }
        }
    }
    
    func selectAnswer(for questionId: UUID, answerIndex: Int) {
        selectedAnswers[questionId] = answerIndex
    }
    
    func getSelectedAnswer(for questionId: UUID) -> Int? {
        return selectedAnswers[questionId]
    }
    
    func nextQuestion() {
        guard let quiz = currentQuiz else { return }
        
        if currentQuestionIndex < quiz.questions.count - 1 {
            currentQuestionIndex += 1
            showExplanation = false
        } else {
            completeQuiz()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            showExplanation = false
        }
    }
    
    func goToQuestion(_ index: Int) {
        guard let quiz = currentQuiz,
              index >= 0 && index < quiz.questions.count else { return }
        
        currentQuestionIndex = index
        showExplanation = false
    }
    
    func toggleExplanation() {
        showExplanation.toggle()
    }
    
    func completeQuiz() {
        timer?.invalidate()
        isQuizCompleted = true
        
        guard let quiz = currentQuiz,
              let startTime = quizStartTime else { return }
        
        let score = calculateScore()
        let timeTaken = Date().timeIntervalSince(startTime)
        
        quizResult = QuizResult(
            quizId: quiz.id,
            quizTitle: quiz.title,
            score: score,
            totalQuestions: quiz.questions.count,
            timeTaken: timeTaken
        )
    }
    
    private func calculateScore() -> Int {
        guard let quiz = currentQuiz else { return 0 }
        
        var correctAnswers = 0
        
        for question in quiz.questions {
            if let selectedAnswer = selectedAnswers[question.id],
               selectedAnswer == question.correctAnswerIndex {
                correctAnswers += 1
            }
        }
        
        return correctAnswers
    }
    
    func getScorePercentage() -> Double {
        guard let quiz = currentQuiz else { return 0.0 }
        let score = calculateScore()
        return Double(score) / Double(quiz.questions.count) * 100
    }
    
    func isAnswerCorrect(questionId: UUID, answerIndex: Int) -> Bool {
        guard let quiz = currentQuiz,
              let question = quiz.questions.first(where: { $0.id == questionId }) else {
            return false
        }
        
        return answerIndex == question.correctAnswerIndex
    }
    
    func getCurrentQuestion() -> Question? {
        guard let quiz = currentQuiz,
              currentQuestionIndex < quiz.questions.count else { return nil }
        
        return quiz.questions[currentQuestionIndex]
    }
    
    func getProgress() -> Double {
        guard let quiz = currentQuiz else { return 0.0 }
        return Double(currentQuestionIndex + 1) / Double(quiz.questions.count)
    }
    
    func getAnsweredQuestionsCount() -> Int {
        guard let quiz = currentQuiz else { return 0 }
        
        var answeredCount = 0
        for question in quiz.questions {
            if selectedAnswers[question.id] != nil {
                answeredCount += 1
            }
        }
        return answeredCount
    }
    
    func isCurrentQuestionAnswered() -> Bool {
        guard let currentQuestion = getCurrentQuestion() else { return false }
        return selectedAnswers[currentQuestion.id] != nil
    }
    
    func canProceedToNext() -> Bool {
        return isCurrentQuestionAnswered()
    }
    
    func resetQuiz() {
        timer?.invalidate()
        currentQuiz = nil
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        isQuizCompleted = false
        timeRemaining = 0
        quizStartTime = nil
        showExplanation = false
        quizResult = nil
    }
    
    func pauseQuiz() {
        timer?.invalidate()
    }
    
    func resumeQuiz() {
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - Quiz Statistics
    func getDetailedResults() -> QuizDetailedResults? {
        guard let quiz = currentQuiz,
              let result = quizResult else { return nil }
        
        var questionResults: [QuestionResult] = []
        
        for question in quiz.questions {
            let selectedAnswer = selectedAnswers[question.id]
            let isCorrect = selectedAnswer == question.correctAnswerIndex
            
            questionResults.append(QuestionResult(
                question: question,
                selectedAnswerIndex: selectedAnswer,
                isCorrect: isCorrect
            ))
        }
        
        return QuizDetailedResults(
            quizResult: result,
            questionResults: questionResults,
            timePerQuestion: result.timeTaken / Double(quiz.questions.count)
        )
    }
}

// MARK: - Supporting Models
struct QuizDetailedResults {
    let quizResult: QuizResult
    let questionResults: [QuestionResult]
    let timePerQuestion: TimeInterval
}

struct QuestionResult {
    let question: Question
    let selectedAnswerIndex: Int?
    let isCorrect: Bool
}
