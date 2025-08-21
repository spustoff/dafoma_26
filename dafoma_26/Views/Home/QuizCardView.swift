//
//  QuizCardView.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

struct QuizCardView: View {
    let quiz: Quiz
    let onTap: () -> Void
    @EnvironmentObject private var userDataService: UserDataService
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with category and difficulty
                HStack {
                    CategoryBadge(category: quiz.category)
                    Spacer()
                    DifficultyBadge(difficulty: quiz.difficulty)
                }
                
                // Title
                Text(quiz.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                // Description
                Text(quiz.description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                Spacer()
                
                // Footer with time and completion status
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.textTertiary)
                        
                        Text("\(quiz.estimatedTime) min")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.textTertiary)
                    }
                    
                    Spacer()
                    
                    if userDataService.hasCompletedQuiz(withId: quiz.id) {
                        CompletionIndicator()
                    }
                }
            }
            .padding(16)
            .frame(height: 160)
            .background(Color.backgroundPrimary)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.categoryColor(for: quiz.category).opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct FeaturedQuizCard: View {
    let quiz: Quiz
    let onTap: () -> Void
    @EnvironmentObject private var userDataService: UserDataService
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Header with gradient background
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.categoryColor(for: quiz.category),
                            Color.categoryColor(for: quiz.category).opacity(0.7)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 100)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            CategoryBadge(category: quiz.category, style: .light)
                            Spacer()
                            if userDataService.hasCompletedQuiz(withId: quiz.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        
                        Spacer()
                        
                        Text(quiz.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                    }
                    .padding(16)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    Text(quiz.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textSecondary)
                        .lineLimit(3)
                    
                    HStack {
                        DifficultyBadge(difficulty: quiz.difficulty)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.textTertiary)
                            
                            Text("\(quiz.estimatedTime) min")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.textTertiary)
                        }
                    }
                }
                .padding(16)
            }
            .frame(width: 280)
            .background(Color.backgroundPrimary)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct CategoryBadge: View {
    let category: QuizCategory
    var style: BadgeStyle = .default
    
    enum BadgeStyle {
        case `default`
        case light
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: category.icon)
                .font(.system(size: 12, weight: .medium))
            
            Text(category.rawValue)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
        }
        .foregroundColor(style == .light ? .white : Color.categoryColor(for: category))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(style == .light ? Color.white.opacity(0.2) : Color.categoryColor(for: category).opacity(0.1))
        )
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<getDifficultyLevel(), id: \.self) { _ in
                Circle()
                    .fill(Color.difficultyColor(for: difficulty))
                    .frame(width: 6, height: 6)
            }
            
            Text(difficulty.rawValue)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color.difficultyColor(for: difficulty))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.difficultyColor(for: difficulty).opacity(0.1))
        )
    }
    
    private func getDifficultyLevel() -> Int {
        switch difficulty {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .expert: return 4
        }
    }
}

struct CompletionIndicator: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.successGreen)
            
            Text("Completed")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.successGreen)
        }
    }
}

struct CategoryOverviewCard: View {
    let category: QuizCategory
    let count: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(Color.categoryColor(for: category).opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: category.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.categoryColor(for: category))
                }
                
                VStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("\(count) quiz\(count != 1 ? "es" : "")")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.backgroundSecondary)
            .cornerRadius(16)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct RecentActivityRow: View {
    let result: QuizResult
    
    var body: some View {
        HStack(spacing: 12) {
            // Score indicator
            ZStack {
                Circle()
                    .fill(getScoreColor().opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Text("\(Int(result.percentage))%")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(getScoreColor())
            }
            
            // Quiz info
            VStack(alignment: .leading, spacing: 2) {
                Text(result.quizTitle)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text("\(result.score)/\(result.totalQuestions) correct • \(result.completionDate.timeAgoDisplay())")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Performance indicator
            Image(systemName: getPerformanceIcon())
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(getScoreColor())
        }
        .padding(16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
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
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Additional Views for other tabs (placeholders for now)
struct CategoriesView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var userDataService: UserDataService
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(QuizCategory.allCases, id: \.self) { category in
                    CategorySection(
                        category: category,
                        quizzes: contentViewModel.getQuizzesForCategory(category)
                    )
                }
            }
            .padding(20)
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct CategorySection: View {
    let category: QuizCategory
    let quizzes: [Quiz]
    @State private var selectedQuiz: Quiz?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.categoryColor(for: category))
                
                Text(category.rawValue)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(quizzes.count)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.backgroundSecondary)
                    .cornerRadius(8)
            }
            
            if quizzes.isEmpty {
                Text("No quizzes available")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
                    .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(quizzes) { quiz in
                        QuizCardView(quiz: quiz) {
                            selectedQuiz = quiz
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedQuiz) { quiz in
            QuizDetailView(quiz: quiz)
        }
    }
}

struct UserProgressView: View {
    @EnvironmentObject private var userDataService: UserDataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Overall Stats
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Progress")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Total Score",
                            value: "\(userDataService.getTotalScore())",
                            icon: "star.fill",
                            color: .achievementGold
                        )
                        
                        StatCard(
                            title: "Average",
                            value: "\(Int(userDataService.getAverageScore()))%",
                            icon: "chart.bar.fill",
                            color: .primaryBlue
                        )
                    }
                }
                
                // Achievements
                if !userDataService.getAchievements().isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Achievements")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(userDataService.getAchievements()) { achievement in
                                AchievementCard(achievement: achievement)
                            }
                        }
                    }
                }
                
                // Recent Results
                if !userDataService.getCompletedQuizzes().isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Results")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        ForEach(Array(userDataService.getCompletedQuizzes().suffix(5).reversed())) { result in
                            RecentActivityRow(result: result)
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.type.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.achievementGold)
            
            Text(achievement.type.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(achievement.unlockedDate.formatted(style: .short))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

struct ProfileView: View {
    @EnvironmentObject private var userDataService: UserDataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.primaryBlue)
                    
                    Text("Quiz Master")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text("Keep learning and growing!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 20)
                
                // Quick Stats
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Stats")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    VStack(spacing: 12) {
                        ProfileStatRow(
                            title: "Quizzes Completed",
                            value: "\(userDataService.userProgress.completedQuizzes.count)",
                            icon: "checkmark.circle.fill"
                        )
                        
                        ProfileStatRow(
                            title: "Current Streak",
                            value: "\(userDataService.getCurrentStreak()) days",
                            icon: "flame.fill"
                        )
                        
                        ProfileStatRow(
                            title: "Total Score",
                            value: "\(userDataService.getTotalScore())",
                            icon: "star.fill"
                        )
                        
                        ProfileStatRow(
                            title: "Achievements",
                            value: "\(userDataService.getAchievements().count)",
                            icon: "trophy.fill"
                        )
                    }
                }
                
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ProfileStatRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primaryBlue)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textSecondary)
        }
        .padding(16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

#Preview("Quiz Card") {
    QuizCardView(
        quiz: Quiz(
            title: "Strategic Planning Fundamentals",
            category: .businessStrategy,
            description: "Test your knowledge of core strategic planning principles and frameworks used by successful companies.",
            difficulty: .beginner,
            estimatedTime: 8,
            questions: []
        )
    ) {}
    .environmentObject(UserDataService())
    .padding()
}

#Preview("Featured Quiz Card") {
    FeaturedQuizCard(
        quiz: Quiz(
            title: "Market Trends 2024",
            category: .marketTrends,
            description: "Stay updated with the latest market trends and consumer behavior patterns.",
            difficulty: .intermediate,
            estimatedTime: 10,
            questions: []
        )
    ) {}
    .environmentObject(UserDataService())
    .padding()
}
