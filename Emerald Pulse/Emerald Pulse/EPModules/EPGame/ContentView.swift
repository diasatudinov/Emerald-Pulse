//
//  ContentView.swift
//  Emerald Pulse
//
//


import SwiftUI

struct GameViewEP: View {
    @StateObject private var vm = MatchGameViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                
                GeometryReader { _ in
                    ZStack {
                        MatchLinesLayer(matches: vm.matches,
                                        numberAnchors: vm.numberAnchors,
                                        wordAnchors: vm.wordAnchors)
                        
                        VStack(spacing: 28) {
                            numbersRow
                            Spacer()
                            wordsRow
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 18)
                    }
                    .onPreferenceChange(NumberAnchorKey.self) { vm.numberAnchors = $0 }
                    .onPreferenceChange(WordAnchorKey.self) { vm.wordAnchors = $0 }
                }
            }.padding(.top, 10)
            
            if vm.matches.count == 3 {
                Color.black.opacity(0.5).ignoresSafeArea()
                
                Image(.gameWinBg)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 260)
                    .overlay(alignment: .center) {
                        VStack {
                            Button {
                                vm.newGame()
                            } label: {
                                Image(.nextBtnEP)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                            }
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(.menuBtnEP)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                            }
                        }.padding(.top, 48)
                    }
            }
        }
        
        .background(
            ZStack {
                Image(.appBgEP)
                    .ignoresSafeArea()
                    
                    
            }
        )
        .onAppear { vm.newGame() }
    }

    private var header: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
                
            } label: {
                Image(.backIconEP)
                    .resizable()
                    .scaledToFit()
                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
            }
            
            Button {
                vm.newGame()
                
            } label: {
                Image(.restartIconEP)
                    .resizable()
                    .scaledToFit()
                    .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
            }
            Spacer()
            
            ZZCoinBg()
            
        }
        .padding(.horizontal, 16)
    }

    private var numbersRow: some View {
        HStack(spacing: 52) {
            ForEach(vm.numbers) { item in
                NumberFlagView(number: item.value,
                               isSelected: vm.selectedNumberID == item.id,
                               isMatched: vm.isNumberMatched(item.id))
                .anchorPreference(key: NumberAnchorKey.self, value: .bounds) { anchor in
                    [item.id: anchor]
                }
                .onTapGesture {
                    vm.tapNumber(item.id)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var wordsRow: some View {
        HStack(spacing: 30) {
            ForEach(vm.words) { item in
                WordBasketView(
                    imageName: item.imageName,
                    text: item.text,
                    isSelected: vm.selectedWordID == item.id,
                    isMatched: vm.isWordMatched(item.id)
                )
                .anchorPreference(key: WordAnchorKey.self, value: .bounds) { anchor in
                    [item.id: anchor]
                }
                .onTapGesture {
                    vm.tapWord(item.id)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - Small UI pieces

private struct NumberFlagView: View {
    let number: Int
    let isSelected: Bool
    let isMatched: Bool
    
    var body: some View {
        Image(.flagImageEP)
            .resizable()
            .scaledToFit()
            .frame(width: 88, height: 105)
            .overlay(alignment: .top) {
                Text("\(number)")
                    .foregroundStyle(.white)
                    .font(.title2).bold()
                    .padding(.top, 23)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
            )
            .opacity(isMatched ? 0.85 : 1.0)
            .contentShape(Rectangle())
            .allowsHitTesting(!isMatched)
        
    }
}

private struct WordBasketView: View {
    let imageName: String
    let text: String
    let isSelected: Bool
    let isMatched: Bool

    var body: some View {
        ZStack {
            // фон-картинка
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 102)
                .clipped()
                .cornerRadius(14)
                .overlay(alignment: .bottom) {
                    Text(text)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(.black.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 8)
                }
            

            // рамки состояния
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? Color.orange : (isMatched ? Color.green : Color.clear), lineWidth: 3)
        }
        .frame(width: 110, height: 110)
        .opacity(isMatched ? 0.88 : 1.0)
        .contentShape(Rectangle())
        .allowsHitTesting(!isMatched)
    }
}

#Preview {
    GameViewEP()
}

enum WordImageMapper {
    static func imageName(for n: Int) -> String {
        precondition(1...100 ~= n)
        if n <= 11 { return "\(n)" }
        if n <= 19 { return "11" }
        if n < 100 { print("\((n / 10) * 10)"); return "\((n / 10) * 10)" } // 23 -> "20"
        return "100"
    }
}
