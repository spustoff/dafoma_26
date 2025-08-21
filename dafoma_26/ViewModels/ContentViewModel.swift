//
//  ContentViewModel.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var featuredQuizzes: [Quiz] = []
    @Published var categorizedQuizzes: [QuizCategory: [Quiz]] = [:]
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var selectedCategory: QuizCategory?
    @Published var selectedDifficulty: Difficulty?
    
    private let quizService = QuizService()
    
    init() {
        loadContent()
    }
    
    func loadContent() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.featuredQuizzes = self.quizService.getFeaturedQuizzes()
            self.categorizeQuizzes()
            self.isLoading = false
        }
    }
    
    private func categorizeQuizzes() {
        let allQuizzes = quizService.quizzes
        
        for category in QuizCategory.allCases {
            categorizedQuizzes[category] = allQuizzes.filter { $0.category == category }
        }
    }
    
    func getFilteredQuizzes() -> [Quiz] {
        var quizzes = quizService.quizzes
        
        // Apply search filter
        if !searchText.isEmpty {
            quizzes = quizzes.filter { quiz in
                quiz.title.localizedCaseInsensitiveContains(searchText) ||
                quiz.description.localizedCaseInsensitiveContains(searchText) ||
                quiz.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply category filter
        if let selectedCategory = selectedCategory {
            quizzes = quizzes.filter { $0.category == selectedCategory }
        }
        
        // Apply difficulty filter
        if let selectedDifficulty = selectedDifficulty {
            quizzes = quizzes.filter { $0.difficulty == selectedDifficulty }
        }
        
        return quizzes
    }
    
    func getQuizzesForCategory(_ category: QuizCategory) -> [Quiz] {
        return categorizedQuizzes[category] ?? []
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedDifficulty = nil
    }
    
    func refreshContent() {
        loadContent()
    }
    
    var hasActiveFilters: Bool {
        return !searchText.isEmpty || selectedCategory != nil || selectedDifficulty != nil
    }
    
    var filteredQuizzesCount: Int {
        return getFilteredQuizzes().count
    }
    
    func getRecommendedQuizzes(for userProgress: UserProgress) -> [Quiz] {
        let userCategories = userProgress.userPreferences.preferredCategories
        let userDifficulty = userProgress.userPreferences.difficultyLevel
        
        var recommendedQuizzes: [Quiz] = []
        
        // First, add quizzes from user's preferred categories
        for category in userCategories {
            let categoryQuizzes = getQuizzesForCategory(category)
                .filter { quiz in !userProgress.completedQuizzes.contains(where: { $0.quizId == quiz.id }) }
            recommendedQuizzes.append(contentsOf: categoryQuizzes)
        }
        
        // If we don't have enough, add quizzes of appropriate difficulty
        if recommendedQuizzes.count < 3 {
            let difficultyQuizzes = quizService.getQuizzes(difficulty: userDifficulty)
                .filter { quiz in !userProgress.completedQuizzes.contains(where: { $0.quizId == quiz.id }) }
                .filter { quiz in !recommendedQuizzes.contains(where: { $0.id == quiz.id }) }
            
            recommendedQuizzes.append(contentsOf: difficultyQuizzes)
        }
        
        // Return top 6 recommendations
        return Array(recommendedQuizzes.prefix(6))
    }
    
    func getPopularQuizzes() -> [Quiz] {
        // In a real app, this would be based on completion statistics
        // For now, return a mix of different categories
        return Array(quizService.quizzes.shuffled().prefix(4))
    }
    
    func getCategoriesWithQuizCount() -> [(category: QuizCategory, count: Int)] {
        return QuizCategory.allCases.map { category in
            (category: category, count: getQuizzesForCategory(category).count)
        }.filter { $0.count > 0 }
    }
}
