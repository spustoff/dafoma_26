//
//  OnboardingPage.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

struct OnboardingPage: View {
    let pageData: OnboardingPageData
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon/Image
            VStack(spacing: 20) {
                Image(systemName: pageData.imageName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.white)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateContent)
                
                // Title
                Text(pageData.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateContent)
                
                // Subtitle
                Text(pageData.subtitle)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.6), value: animateContent)
            }
            
            // Description
            Text(pageData.description)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .padding(.horizontal, 32)
                .offset(y: animateContent ? 0 : 20)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.8), value: animateContent)
            
            Spacer()
        }
        .onAppear {
            animateContent = true
        }
        .onDisappear {
            animateContent = false
        }
    }
}

struct OnboardingPreferencesPage: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(.white)
                        .scaleEffect(animateContent ? 1.0 : 0.8)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateContent)
                    
                    Text("Customize Your Experience")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .offset(y: animateContent ? 0 : 30)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateContent)
                    
                    Text("Choose your interests to get personalized quiz recommendations")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .offset(y: animateContent ? 0 : 20)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.6), value: animateContent)
                }
                .padding(.top, 40)
                
                // Categories Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Your Interests")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(QuizCategory.allCases, id: \.self) { category in
                            CategorySelectionCard(
                                category: category,
                                isSelected: viewModel.selectedCategories.contains(category)
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.toggleCategory(category)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .offset(y: animateContent ? 0 : 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.8), value: animateContent)
                
                // Difficulty Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Choose Your Level")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 8) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            DifficultySelectionRow(
                                difficulty: difficulty,
                                isSelected: viewModel.selectedDifficulty == difficulty
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.selectedDifficulty = difficulty
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .offset(y: animateContent ? 0 : 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.0), value: animateContent)
                
                // Notifications Toggle
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Enable Notifications")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Get reminded about new quizzes and achievements")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $viewModel.notificationsEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: .white))
                            .scaleEffect(1.1)
                    }
                    .padding(.horizontal, 20)
                }
                .offset(y: animateContent ? 0 : 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(1.2), value: animateContent)
                
                Spacer(minLength: 100)
            }
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct CategorySelectionCard: View {
    let category: QuizCategory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(isSelected ? 0.6 : 0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct DifficultySelectionRow: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Circle()
                    .fill(isSelected ? Color.white : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(difficulty.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(getDifficultyDescription(difficulty))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                // Difficulty indicator
                HStack(spacing: 4) {
                    ForEach(0..<getDifficultyLevel(difficulty), id: \.self) { _ in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                    }
                    ForEach(getDifficultyLevel(difficulty)..<4, id: \.self) { _ in
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(isSelected ? 0.4 : 0.2), lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
    
    private func getDifficultyDescription(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .beginner: return "Perfect for getting started"
        case .intermediate: return "For those with some experience"
        case .advanced: return "Challenging questions for experts"
        case .expert: return "The ultimate test of knowledge"
        }
    }
    
    private func getDifficultyLevel(_ difficulty: Difficulty) -> Int {
        switch difficulty {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .expert: return 4
        }
    }
}

#Preview("Onboarding Page") {
    OnboardingPage(pageData: OnboardingPageData(
        title: "Welcome to QuizzleHub Avi",
        subtitle: "Your Premium Learning Companion",
        description: "Discover engaging quizzes that blend entertainment with business insights. Learn while having fun!",
        imageName: "brain.head.profile",
        backgroundColor: .primaryBlue
    ))
}

#Preview("Preferences Page") {
    OnboardingPreferencesPage()
        .environmentObject(OnboardingViewModel())
}
