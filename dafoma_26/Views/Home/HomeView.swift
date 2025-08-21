//
//  HomeView.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userDataService: UserDataService
    @StateObject private var contentViewModel = ContentViewModel()
    @State private var showingProfile = false
    @State private var showingSearch = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                HomeContentView()
                    .environmentObject(contentViewModel)
                    .environmentObject(userDataService)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            // Categories Tab
            NavigationView {
                CategoriesView()
                    .environmentObject(contentViewModel)
                    .environmentObject(userDataService)
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                Text("Categories")
            }
            .tag(1)
            
            // Progress Tab
            NavigationView {
                UserProgressView()
                    .environmentObject(userDataService)
            }
            .tabItem {
                Image(systemName: "chart.line.uptrend.xyaxis")
                Text("Progress")
            }
            .tag(2)
            
            // Profile Tab
            NavigationView {
                ProfileView()
                    .environmentObject(userDataService)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(3)
        }
        .accentColor(.primaryBlue)
    }
}

struct HomeContentView: View {
    @EnvironmentObject private var contentViewModel: ContentViewModel
    @EnvironmentObject private var userDataService: UserDataService
    @State private var selectedQuiz: Quiz?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Header
                HeaderView()
                
                // Featured Quizzes
                FeaturedQuizzesSection(
                    quizzes: contentViewModel.featuredQuizzes,
                    onQuizSelected: { quiz in
                        selectedQuiz = quiz
                    }
                )
                
                // Recommended Quizzes
                if !userDataService.userProgress.completedQuizzes.isEmpty {
                    RecommendedQuizzesSection(
                        quizzes: contentViewModel.getRecommendedQuizzes(for: userDataService.userProgress),
                        onQuizSelected: { quiz in
                            selectedQuiz = quiz
                        }
                    )
                }
                
                // Categories Overview
                CategoriesOverviewSection(
                    categories: contentViewModel.getCategoriesWithQuizCount(),
                    onCategorySelected: { category in
                        // Navigate to category view
                    }
                )
                
                // Recent Activity
                if !userDataService.userProgress.completedQuizzes.isEmpty {
                    RecentActivitySection(
                        recentQuizzes: Array(userDataService.userProgress.completedQuizzes.suffix(3).reversed())
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("QuizzleHub Avi")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            contentViewModel.refreshContent()
        }
        .sheet(item: $selectedQuiz) { quiz in
            QuizDetailView(quiz: quiz)
                .environmentObject(userDataService)
        }
    }
}

struct HeaderView: View {
    @EnvironmentObject private var userDataService: UserDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                    
                    Text("Ready to learn?")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                
                Spacer()
                
                // Streak Counter
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("\(userDataService.getCurrentStreak())")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    Text("day streak")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.backgroundSecondary)
                .cornerRadius(12)
            }
            
            // Stats Row
            HStack(spacing: 16) {
                StatCard(
                    title: "Completed",
                    value: "\(userDataService.userProgress.completedQuizzes.count)",
                    icon: "checkmark.circle.fill",
                    color: .successGreen
                )
                
                StatCard(
                    title: "Average",
                    value: "\(Int(userDataService.getAverageScore()))%",
                    icon: "chart.bar.fill",
                    color: .primaryBlue
                )
                
                StatCard(
                    title: "Achievements",
                    value: "\(userDataService.getAchievements().count)",
                    icon: "star.fill",
                    color: .achievementGold
                )
            }
        }
        .padding(.top, 10)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.backgroundSecondary)
        .cornerRadius(12)
    }
}

struct FeaturedQuizzesSection: View {
    let quizzes: [Quiz]
    let onQuizSelected: (Quiz) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Featured Quizzes", subtitle: "Handpicked for you")
            
            if quizzes.isEmpty {
                EmptyStateView(
                    icon: "star.fill",
                    title: "No featured quizzes",
                    description: "Check back later for new content"
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(quizzes) { quiz in
                            FeaturedQuizCard(quiz: quiz) {
                                onQuizSelected(quiz)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .offset(x: -20)
            }
        }
    }
}

struct RecommendedQuizzesSection: View {
    let quizzes: [Quiz]
    let onQuizSelected: (Quiz) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Recommended for You", subtitle: "Based on your interests")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(quizzes.prefix(4)) { quiz in
                    QuizCardView(quiz: quiz) {
                        onQuizSelected(quiz)
                    }
                }
            }
        }
    }
}

struct CategoriesOverviewSection: View {
    let categories: [(category: QuizCategory, count: Int)]
    let onCategorySelected: (QuizCategory) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Explore Categories", subtitle: "Find your perfect quiz")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(categories.prefix(6), id: \.category) { item in
                    CategoryOverviewCard(category: item.category, count: item.count) {
                        onCategorySelected(item.category)
                    }
                }
            }
        }
    }
}

struct RecentActivitySection: View {
    let recentQuizzes: [QuizResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "Recent Activity", subtitle: "Your latest achievements")
            
            VStack(spacing: 12) {
                ForEach(recentQuizzes) { result in
                    RecentActivityRow(result: result)
                }
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(subtitle)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.textSecondary)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.textTertiary)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.textSecondary)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    HomeView()
        .environmentObject(UserDataService())
}
