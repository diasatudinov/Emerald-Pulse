//
//  IFDailyView.swift
//  Emerald Pulse
//
//


import SwiftUI

struct EPDailyView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("claim") var claim: Bool = false
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack {
                    
                    HStack(alignment: .center) {
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
                        
                    }.padding(.horizontal).padding([.top])
                }
                
                
                Image(.dailyBgEP)
                    .resizable()
                    .scaledToFit()
                    .overlay(alignment: .bottom) {
                        Button {
                            claim.toggle()
                        } label: {
                            
                            Image(!claim ? .claimBtnEP:.collectedBtnEP)
                                .resizable()
                                .scaledToFit()
                                .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:50)
                                .padding(.bottom, 25)
                        }
                    }
                
                Spacer()
            }
        }.background(
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
    EPDailyView()
}
