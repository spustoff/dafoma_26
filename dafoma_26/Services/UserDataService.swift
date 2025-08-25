//
//  UserDataService.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation

class UserDataService: ObservableObject {
    @Published var userProgress: UserProgress
    
    private let userDefaultsKey = "QuizzleHubUserProgress"
    
    init() {
        self.userProgress = UserDataService.loadUserProgress()
    }
    
    func saveUserProgress() {
        if let encoded = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    static func loadUserProgress() -> UserProgress {
        if let data = UserDefaults.standard.data(forKey: "QuizzleHubUserProgress"),
           let progress = try? JSONDecoder().decode(UserProgress.self, from: data) {
            return progress
        }
        return UserProgress()
    }
    
    func addQuizResult(_ result: QuizResult) {
        userProgress.addQuizResult(result)
        saveUserProgress()
    }
    
    func updatePreferences(_ preferences: UserPreferences) {
        userProgress.userPreferences = preferences
        saveUserProgress()
    }
    
    func addFavoriteCategory(_ category: QuizCategory) {
        if !userProgress.favoriteCategories.contains(category) {
            userProgress.favoriteCategories.append(category)
            saveUserProgress()
        }
    }
    
    func removeFavoriteCategory(_ category: QuizCategory) {
        userProgress.favoriteCategories.removeAll { $0 == category }
        saveUserProgress()
    }
    
    func getCompletedQuizzes() -> [QuizResult] {
        return userProgress.completedQuizzes
    }
    
    func getAchievements() -> [Achievement] {
        return userProgress.achievements
    }
    
    func getCurrentStreak() -> Int {
        return userProgress.streak
    }
    
    func getTotalScore() -> Int {
        return userProgress.totalScore
    }
    
    func getAverageScore() -> Double {
        guard !userProgress.completedQuizzes.isEmpty else { return 0.0 }
        let totalPercentage = userProgress.completedQuizzes.reduce(0.0) { $0 + $1.percentage }
        return totalPercentage / Double(userProgress.completedQuizzes.count)
    }
    
    func getQuizzesByCategory() -> [QuizCategory: Int] {
        var categoryCount: [QuizCategory: Int] = [:]
        
        for result in userProgress.completedQuizzes {
            // Note: We would need to store category in QuizResult or lookup from QuizService
            // For now, we'll implement this when we have the full integration
        }
        
        return categoryCount
    }
    
    func hasCompletedQuiz(withId quizId: UUID) -> Bool {
        return userProgress.completedQuizzes.contains { $0.quizId == quizId }
    }
    
    func getBestScore(for quizId: UUID) -> QuizResult? {
        let results = userProgress.completedQuizzes.filter { $0.quizId == quizId }
        return results.max { $0.percentage < $1.percentage }
    }
    
    func resetProgress() {
        userProgress = UserProgress()
        saveUserProgress()
    }
}

