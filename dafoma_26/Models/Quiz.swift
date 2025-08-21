//
//  Quiz.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import Foundation

struct Quiz: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let category: QuizCategory
    let description: String
    let difficulty: Difficulty
    let estimatedTime: Int // in minutes
    let questions: [Question]
    let isBusinessFocused: Bool
    
    init(id: UUID = UUID(), title: String, category: QuizCategory, description: String, difficulty: Difficulty, estimatedTime: Int, questions: [Question], isBusinessFocused: Bool = true) {
        self.id = id
        self.title = title
        self.category = category
        self.description = description
        self.difficulty = difficulty
        self.estimatedTime = estimatedTime
        self.questions = questions
        self.isBusinessFocused = isBusinessFocused
    }
}

struct Question: Identifiable, Codable, Hashable {
    let id: UUID
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String?
    
    init(id: UUID = UUID(), text: String, options: [String], correctAnswerIndex: Int, explanation: String? = nil) {
        self.id = id
        self.text = text
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.explanation = explanation
    }
}

enum QuizCategory: String, CaseIterable, Codable {
    case businessStrategy = "Business Strategy"
    case marketTrends = "Market Trends"
    case entrepreneurship = "Entrepreneurship"
    case innovation = "Innovation"
    case leadership = "Leadership"
    case finance = "Finance"
    case technology = "Technology"
    case marketing = "Marketing"
    
    var icon: String {
        switch self {
        case .businessStrategy: return "chart.line.uptrend.xyaxis"
        case .marketTrends: return "chart.bar.fill"
        case .entrepreneurship: return "lightbulb.fill"
        case .innovation: return "gear.badge"
        case .leadership: return "person.3.fill"
        case .finance: return "dollarsign.circle.fill"
        case .technology: return "laptopcomputer"
        case .marketing: return "megaphone.fill"
        }
    }
    
    var color: String {
        switch self {
        case .businessStrategy: return "blue"
        case .marketTrends: return "green"
        case .entrepreneurship: return "orange"
        case .innovation: return "purple"
        case .leadership: return "red"
        case .finance: return "mint"
        case .technology: return "cyan"
        case .marketing: return "pink"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case expert = "Expert"
    
    var color: String {
        switch self {
        case .beginner: return "green"
        case .intermediate: return "yellow"
        case .advanced: return "orange"
        case .expert: return "red"
        }
    }
}
