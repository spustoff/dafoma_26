//
//  UserProgress.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation

struct UserProgress: Codable {
    var completedQuizzes: [QuizResult]
    var favoriteCategories: [QuizCategory]
    var totalScore: Int
    var streak: Int
    var lastPlayedDate: Date?
    var achievements: [Achievement]
    var userPreferences: UserPreferences
    
    init() {
        self.completedQuizzes = []
        self.favoriteCategories = []
        self.totalScore = 0
        self.streak = 0
        self.lastPlayedDate = nil
        self.achievements = []
        self.userPreferences = UserPreferences()
    }
    
    mutating func addQuizResult(_ result: QuizResult) {
        completedQuizzes.append(result)
        totalScore += result.score
        updateStreak()
        checkForAchievements()
    }
    
    private mutating func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastPlayed = lastPlayedDate {
            let lastPlayedDay = Calendar.current.startOfDay(for: lastPlayed)
            let daysDifference = Calendar.current.dateComponents([.day], from: lastPlayedDay, to: today).day ?? 0
            
            if daysDifference == 1 {
                streak += 1
            } else if daysDifference > 1 {
                streak = 1
            }
        } else {
            streak = 1
        }
        
        lastPlayedDate = Date()
    }
    
    private mutating func checkForAchievements() {
        // First Quiz Achievement
        if completedQuizzes.count == 1 && !achievements.contains(where: { $0.type == .firstQuiz }) {
            achievements.append(Achievement(type: .firstQuiz, unlockedDate: Date()))
        }
        
        // Perfect Score Achievement
        if let lastResult = completedQuizzes.last, lastResult.percentage == 100 && !achievements.contains(where: { $0.type == .perfectScore }) {
            achievements.append(Achievement(type: .perfectScore, unlockedDate: Date()))
        }
        
        // Streak Achievements
        if streak >= 7 && !achievements.contains(where: { $0.type == .weekStreak }) {
            achievements.append(Achievement(type: .weekStreak, unlockedDate: Date()))
        }
        
        if streak >= 30 && !achievements.contains(where: { $0.type == .monthStreak }) {
            achievements.append(Achievement(type: .monthStreak, unlockedDate: Date()))
        }
        
        // Quiz Count Achievements
        if completedQuizzes.count >= 10 && !achievements.contains(where: { $0.type == .tenQuizzes }) {
            achievements.append(Achievement(type: .tenQuizzes, unlockedDate: Date()))
        }
        
        if completedQuizzes.count >= 50 && !achievements.contains(where: { $0.type == .fiftyQuizzes }) {
            achievements.append(Achievement(type: .fiftyQuizzes, unlockedDate: Date()))
        }
    }
}

struct QuizResult: Identifiable, Codable {
    let id: UUID
    let quizId: UUID
    let quizTitle: String
    let score: Int
    let totalQuestions: Int
    let percentage: Double
    let completionDate: Date
    let timeTaken: TimeInterval
    
    init(id: UUID = UUID(), quizId: UUID, quizTitle: String, score: Int, totalQuestions: Int, timeTaken: TimeInterval) {
        self.id = id
        self.quizId = quizId
        self.quizTitle = quizTitle
        self.score = score
        self.totalQuestions = totalQuestions
        self.percentage = totalQuestions > 0 ? Double(score) / Double(totalQuestions) * 100 : 0
        self.completionDate = Date()
        self.timeTaken = timeTaken
    }
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    let type: AchievementType
    let unlockedDate: Date
    
    init(id: UUID = UUID(), type: AchievementType, unlockedDate: Date) {
        self.id = id
        self.type = type
        self.unlockedDate = unlockedDate
    }
}

enum AchievementType: String, CaseIterable, Codable {
    case firstQuiz = "First Quiz"
    case perfectScore = "Perfect Score"
    case weekStreak = "Week Streak"
    case monthStreak = "Month Streak"
    case tenQuizzes = "Ten Quizzes"
    case fiftyQuizzes = "Fifty Quizzes"
    
    var title: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .firstQuiz: return "Complete your first quiz"
        case .perfectScore: return "Get 100% on a quiz"
        case .weekStreak: return "Play for 7 days in a row"
        case .monthStreak: return "Play for 30 days in a row"
        case .tenQuizzes: return "Complete 10 quizzes"
        case .fiftyQuizzes: return "Complete 50 quizzes"
        }
    }
    
    var icon: String {
        switch self {
        case .firstQuiz: return "star.fill"
        case .perfectScore: return "crown.fill"
        case .weekStreak: return "flame.fill"
        case .monthStreak: return "flame.circle.fill"
        case .tenQuizzes: return "10.circle.fill"
        case .fiftyQuizzes: return "50.circle.fill"
        }
    }
}

struct UserPreferences: Codable {
    var preferredCategories: [QuizCategory]
    var difficultyLevel: Difficulty
    var notificationsEnabled: Bool
    var soundEnabled: Bool
    
    init() {
        self.preferredCategories = []
        self.difficultyLevel = .beginner
        self.notificationsEnabled = true
        self.soundEnabled = true
    }
}
