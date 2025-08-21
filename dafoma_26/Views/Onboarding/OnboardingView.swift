//
//  OnboardingView.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var viewModel: OnboardingViewModel
    @EnvironmentObject private var userDataService: UserDataService
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        viewModel.onboardingPages[viewModel.currentPage].backgroundColor,
                        viewModel.onboardingPages[viewModel.currentPage].backgroundColor.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress Bar
                    VStack {
                        HStack {
                            ForEach(0..<viewModel.onboardingPages.count, id: \.self) { index in
                                Rectangle()
                                    .fill(index <= viewModel.currentPage ? Color.white : Color.white.opacity(0.3))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                    
                    // Content
                    TabView(selection: $viewModel.currentPage) {
                        ForEach(0..<viewModel.onboardingPages.count, id: \.self) { index in
                            if index < viewModel.onboardingPages.count - 1 {
                                OnboardingPage(pageData: viewModel.onboardingPages[index])
                                    .tag(index)
                            } else {
                                OnboardingPreferencesPage()
                                    .tag(index)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.smooth, value: viewModel.currentPage)
                    
                    // Navigation Buttons
                    VStack(spacing: 16) {
                        if viewModel.currentPage < viewModel.onboardingPages.count - 1 {
                            // Regular navigation
                            HStack {
                                if viewModel.currentPage > 0 {
                                    Button("Previous") {
                                        withAnimation(.smooth) {
                                            viewModel.previousPage()
                                        }
                                    }
                                    .secondaryButtonStyle()
                                }
                                
                                Spacer()
                                
                                Button("Next") {
                                    withAnimation(.smooth) {
                                        viewModel.nextPage()
                                    }
                                }
                                .primaryButtonStyle()
                            }
                            .padding(.horizontal, 20)
                        } else {
                            // Final page with completion
                            VStack(spacing: 12) {
                                Button("Get Started") {
                                    withAnimation(.smooth) {
                                        viewModel.completeOnboarding()
                                    }
                                }
                                .primaryButtonStyle()
                                .disabled(!viewModel.canProceed)
                                .opacity(viewModel.canProceed ? 1.0 : 0.6)
                                
                                if viewModel.currentPage > 0 {
                                    Button("Back") {
                                        withAnimation(.smooth) {
                                            viewModel.previousPage()
                                        }
                                    }
                                    .secondaryButtonStyle()
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Skip button for non-final pages
                        if viewModel.currentPage < viewModel.onboardingPages.count - 1 {
                            Button("Skip") {
                                withAnimation(.smooth) {
                                    viewModel.completeOnboarding()
                                }
                            }
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 16, weight: .medium))
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(OnboardingViewModel())
        .environmentObject(UserDataService())
}
