//
//  EPSettingsView.swift
//  Emerald Pulse
//
//

import SwiftUI

struct EPSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var settingsVM = IFSettingsViewModel()
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack {
                    
                    Image(.settingsBgEP)
                        .resizable()
                        .scaledToFit()
                    
                    
                    VStack(spacing: 5) {
                        HStack(spacing: 20) {
                            VStack(spacing: 10) {
                                HStack {
                                    Button {
                                        withAnimation {
                                            settingsVM.soundEnabled.toggle()
                                        }
                                    } label: {
                                        Image(settingsVM.soundEnabled ? .onEP:.offEP)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:70)
                                    }
                                }
                            }
                        }
                        
                        Image(.languageIconEP)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:100)
                        
                        
                    }
                    .padding(.top,30)
                }
                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 88:292)
                
            }
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconEP)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                    
                    ZZCoinBg()
                    
                }.padding()
                Spacer()
                
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                Image(.appBgEP)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            }
        )
    }
}

#Preview {
    EPSettingsView()
}
