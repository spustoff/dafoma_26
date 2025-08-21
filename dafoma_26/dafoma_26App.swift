//
//  MainApp.swift
//  QuizzleHub Avi
//
//  Created by Вячеслав on 8/21/25.
//

import SwiftUI

@main
struct QuizzleHubAviApp: App {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    @StateObject private var userDataService = UserDataService()
    
    var body: some Scene {
        WindowGroup {
            if onboardingViewModel.isOnboardingCompleted {
                HomeView()
                    .environmentObject(userDataService)
            } else {
                OnboardingView()
                    .environmentObject(onboardingViewModel)
                    .environmentObject(userDataService)
            }
        }
    }
}
