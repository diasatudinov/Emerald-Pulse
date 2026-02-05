//
//  EPMenuView.swift
//  Emerald Pulse
//
//

import SwiftUI

struct EPMenuView: View {
    @State private var showGame = false
    @State private var showAchievement = false
    @State private var showSettings = false
    @State private var showDailyReward = false
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 0) {
                HStack {
                    Image("menuLogoEP")
                        .resizable()
                        .scaledToFit()
                        .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 140:100)
                    
                    Spacer()
                    
                    ZZCoinBg()
                    
                }
                
                VStack {
                    
                    Button {
                        showGame = true
                    } label: {
                        Image("playIconEP")
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                    }
                    
                    HStack {
                        
                        Button {
                            showDailyReward = true
                        } label: {
                            Image("dailyIconEP")
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                        }
                        
                        Button {
                            showAchievement = true
                        } label: {
                            Image("achievementsIconEP")
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                        }
                    }
                    
                    Button {
                        showSettings = true
                    } label: {
                        Image("settingsIconEP")
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:75)
                    }
                }
                
                Spacer()
                
            }
            .padding(10)
            
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(.appBgEP)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
            }
        )
        .fullScreenCover(isPresented: $showGame) {
            GameViewEP()
        }
        .fullScreenCover(isPresented: $showSettings) {
            EPSettingsView()
        }
        .fullScreenCover(isPresented: $showAchievement) {
            EPAchievementsView()
        }
        .fullScreenCover(isPresented: $showDailyReward) {
            EPDailyView()
        }
        
    }
}

#Preview {
    EPMenuView()
}
