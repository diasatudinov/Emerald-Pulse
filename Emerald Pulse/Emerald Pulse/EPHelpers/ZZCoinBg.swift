//
//  ZZCoinBg.swift
//  Emerald Pulse
//
//


import SwiftUI

struct ZZCoinBg: View {
    @StateObject var user = ZZUser.shared
    var height: CGFloat = ZZDeviceManager.shared.deviceType == .pad ? 80:62
    var body: some View {
        ZStack {
            Image(.coinsBgEP)
                .resizable()
                .scaledToFit()
            
            Text("\(user.money)")
                .font(.system(size: ZZDeviceManager.shared.deviceType == .pad ? 45:28, weight: .bold))
                .foregroundStyle(.yellow)
                .textCase(.uppercase)
                .offset(x: 15, y: 0)
            
            
            
        }.frame(height: height)
        
    }
}

#Preview {
    ZZCoinBg()
}
