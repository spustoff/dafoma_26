//
//  OnboardingViewModel.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var isOnboardingCompleted: Bool = false
    @Published var selectedCategories: Set<QuizCategory> = []
    @Published var selectedDifficulty: Difficulty = .beginner
    @Published var notificationsEnabled: Bool = true
    
    private let onboardingCompletedKey = "OnboardingCompleted"
    
    init() {
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: onboardingCompletedKey)
    }
    
    let onboardingPages: [OnboardingPageData] = [
        OnboardingPageData(
            title: "Welcome to QuizzleHub Avi",
            subtitle: "Your Premium Learning Companion",
            description: "Discover engaging quizzes that blend entertainment with business insights. Learn while having fun!",
            imageName: "brain.head.profile",
            backgroundColor: .primaryBlue
        ),
        OnboardingPageData(
            title: "Business-Focused Content",
            subtitle: "Learn What Matters",
            description: "Explore quizzes about market trends, entrepreneurship, leadership, and more. Stay ahead in your career!",
            imageName: "chart.line.uptrend.xyaxis",
            backgroundColor: .primaryGreen
        ),
        OnboardingPageData(
            title: "Track Your Progress",
            subtitle: "See How You Improve",
            description: "Monitor your learning journey with detailed analytics, achievements, and streak tracking.",
            imageName: "chart.bar.fill",
            backgroundColor: .primaryPurple
        ),
        OnboardingPageData(
            title: "Personalized Experience",
            subtitle: "Tailored Just for You",
            description: "Get quiz recommendations based on your interests and skill level. Your learning, your way.",
            imageName: "person.crop.circle.badge.checkmark",
            backgroundColor: .orange
        )
    ]
    
    func nextPage() {
        if currentPage < onboardingPages.count - 1 {
            currentPage += 1
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
    
    func goToPage(_ page: Int) {
        if page >= 0 && page < onboardingPages.count {
            currentPage = page
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: onboardingCompletedKey)
        
        // Save user preferences
        var preferences = UserPreferences()
        preferences.preferredCategories = Array(selectedCategories)
        preferences.difficultyLevel = selectedDifficulty
        preferences.notificationsEnabled = notificationsEnabled
        
        // This would typically be handled by the UserDataService
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: "UserPreferences")
        }
    }
    
    func resetOnboarding() {
        isOnboardingCompleted = false
        currentPage = 0
        selectedCategories.removeAll()
        selectedDifficulty = .beginner
        notificationsEnabled = true
        UserDefaults.standard.set(false, forKey: onboardingCompletedKey)
    }
    
    func toggleCategory(_ category: QuizCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
    }
    
    var canProceed: Bool {
        switch currentPage {
        case onboardingPages.count - 1:
            return !selectedCategories.isEmpty
        default:
            return true
        }
    }
    
    var progressPercentage: Double {
        return Double(currentPage + 1) / Double(onboardingPages.count)
    }
}

struct OnboardingPageData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}
