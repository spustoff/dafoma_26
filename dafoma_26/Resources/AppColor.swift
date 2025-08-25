//
//  AppColor.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

extension Color {
    // Primary Brand Colors
    static let primaryBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let primaryPurple = Color(red: 0.35, green: 0.34, blue: 0.84)
    static let primaryGreen = Color(red: 0.2, green: 0.78, blue: 0.35)
    
    // Secondary Colors
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let mediumGray = Color(red: 0.68, green: 0.68, blue: 0.70)
    static let darkGray = Color(red: 0.28, green: 0.28, blue: 0.30)
    
    // Background Colors
    static let backgroundPrimary = Color(UIColor.systemBackground)
    static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
    static let backgroundTertiary = Color(UIColor.tertiarySystemBackground)
    
    // Text Colors
    static let textPrimary = Color(UIColor.label)
    static let textSecondary = Color(UIColor.secondaryLabel)
    static let textTertiary = Color(UIColor.tertiaryLabel)
    
    // Quiz Category Colors
    static let businessStrategy = Color.blue
    static let marketTrends = Color.green
    static let entrepreneurship = Color.orange
    static let innovation = Color.purple
    static let leadership = Color.red
    static let finance = Color.mint
    static let technology = Color.cyan
    static let marketing = Color.pink
    
    // Difficulty Colors
    static let beginnerGreen = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let intermediateYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let advancedOrange = Color(red: 1.0, green: 0.58, blue: 0.0)
    static let expertRed = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    // Achievement Colors
    static let achievementGold = Color(red: 1.0, green: 0.84, blue: 0.0)
    static let achievementSilver = Color(red: 0.75, green: 0.75, blue: 0.75)
    static let achievementBronze = Color(red: 0.8, green: 0.5, blue: 0.2)
    
    // Status Colors
    static let successGreen = Color(red: 0.2, green: 0.78, blue: 0.35)
    static let warningYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let errorRed = Color(red: 1.0, green: 0.23, blue: 0.19)
    
    // Gradient Colors
    static let gradientStart = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let gradientEnd = Color(red: 0.35, green: 0.34, blue: 0.84)
    
    static var primaryGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [gradientStart, gradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.backgroundSecondary]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Dynamic Color Support
extension Color {
    static func categoryColor(for category: QuizCategory) -> Color {
        switch category {
        case .businessStrategy: return .businessStrategy
        case .marketTrends: return .marketTrends
        case .entrepreneurship: return .entrepreneurship
        case .innovation: return .innovation
        case .leadership: return .leadership
        case .finance: return .finance
        case .technology: return .technology
        case .marketing: return .marketing
        }
    }
    
    static func difficultyColor(for difficulty: Difficulty) -> Color {
        switch difficulty {
        case .beginner: return .beginnerGreen
        case .intermediate: return .intermediateYellow
        case .advanced: return .advancedOrange
        case .expert: return .expertRed
        }
    }
}

