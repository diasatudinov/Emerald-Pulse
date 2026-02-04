//
//  EPAchievementsView.swift
//  Emerald Pulse
//
//

import SwiftUI

struct EPAchievementsView: View {
    @StateObject var user = ZZUser.shared
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = EPAchievementsViewModel()
    @State private var index = 0
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack {
                    HStack {
                        Image(.achievementsTextEP)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 80:70)
                    }
                    
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
                
                VStack {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.achievements, id: \.self) { item in
                                Image(item.isAchieved ? item.image : "\(item.image)Off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .onTapGesture {
                                        if item.isAchieved {
                                            user.updateUserMoney(for: 10)
                                        }
                                        viewModel.achieveToggle(item)
                                    }
                                
                            }
                        }
                    }
                    
                }
                .frame(maxHeight: .infinity)
                
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
    EPAchievementsView()
}
