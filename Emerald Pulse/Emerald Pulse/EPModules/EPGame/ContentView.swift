import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MatchGameViewModel()

    var body: some View {
        VStack(spacing: 20) {
            header

            GeometryReader { _ in
                ZStack {
                    // Линии
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
            }
        }
        .padding(.top, 12)
        .onAppear { vm.newGame() }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Соедини число со словом")
                    .font(.title3).bold()
                Text(vm.statusText)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button("Новая игра") { vm.newGame() }
                .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
    }

    private var numbersRow: some View {
        HStack(spacing: 12) {
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
        HStack(spacing: 12) {
            ForEach(vm.words) { item in
                WordBasketView(text: item.text,
                               isSelected: vm.selectedWordID == item.id,
                               isMatched: vm.isWordMatched(item.id))
                .anchorPreference(key: WordAnchorKey.self, value: .bounds) { anchor in
                    [item.id: anchor]
                }
                .onTapGesture {
                    vm.tapWord(item.id)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        // Считываем anchors из Preference и кладём в VM
        .onPreferenceChange(NumberAnchorKey.self) { vm.numberAnchors = $0 }
        .onPreferenceChange(WordAnchorKey.self) { vm.wordAnchors = $0 }
    }
}

// MARK: - Small UI pieces

private struct NumberFlagView: View {
    let number: Int
    let isSelected: Bool
    let isMatched: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(isMatched ? Color.green.opacity(0.18) : Color.blue.opacity(0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
                )

            VStack(spacing: 8) {
                Text("🏳️")
                    .font(.title)
                Text("\(number)")
                    .font(.title2).bold()
            }
            .padding(.vertical, 10)
        }
        .frame(width: 110, height: 110)
        .opacity(isMatched ? 0.85 : 1.0)
        .contentShape(Rectangle())
        .allowsHitTesting(!isMatched)
    }
}

private struct WordBasketView: View {
    let text: String
    let isSelected: Bool
    let isMatched: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(isMatched ? Color.green.opacity(0.18) : Color.brown.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 3)
                )

            VStack(spacing: 8) {
                Text("🧺")
                    .font(.title)
                Text(text)
                    .font(.headline)
                    .minimumScaleFactor(0.6)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 6)
            }
            .padding(.vertical, 10)
        }
        .frame(width: 110, height: 110)
        .opacity(isMatched ? 0.85 : 1.0)
        .contentShape(Rectangle())
        .allowsHitTesting(!isMatched)
    }
}
