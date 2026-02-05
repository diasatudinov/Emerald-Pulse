//
//  NumberItem.swift
//  Emerald Pulse
//
//


import SwiftUI

struct NumberItem: Identifiable {
    let id = UUID()
    let value: Int
}

struct WordItem: Identifiable {
    let id = UUID()
    let imageName: String   // "1", "2", ... "11", "20", ... "100"
    let text: String        // "seventeen", "twenty-one", ...
    let numberValue: Int    // правильное число для этой карточки
}

struct MatchPair: Identifiable, Equatable {
    let id = UUID()
    let numberID: UUID
    let wordID: UUID
}

final class MatchGameViewModel: ObservableObject {
    @Published var numbers: [NumberItem] = []
    @Published var words: [WordItem] = []

    @Published var selectedNumberID: UUID? = nil
    @Published var selectedWordID: UUID? = nil

    @Published var matches: [MatchPair] = []
    @Published var statusText: String = "Тапни число сверху, затем слово снизу."

    // anchors для линий
    @Published var numberAnchors: [UUID: Anchor<CGRect>] = [:]
    @Published var wordAnchors: [UUID: Anchor<CGRect>] = [:]

    func newGame() {
        selectedNumberID = nil
        selectedWordID = nil
        matches.removeAll()
        statusText = "Tap a number, then tap the correct word card."

        // 3 числа так, чтобы не было одинаковых imageKey (иначе 2 одинаковые картинки снизу)
        var picked: [Int] = []
        var usedImageKeys = Set<String>()

        while picked.count < 3 {
            let candidate = Int.random(in: 1...100)
            let key = WordImageMapper.imageName(for: candidate)
            if usedImageKeys.contains(key) { continue }
            usedImageKeys.insert(key)
            picked.append(candidate)
        }

        numbers = picked.map { NumberItem(value: $0) }

        let generatedWords = picked.map { v in
            WordItem(
                imageName: WordImageMapper.imageName(for: v),
                text: EnglishNumberSpeller.spell(v),
                numberValue: v
            )
        }
        words = generatedWords.shuffled()
    }

    func tapNumber(_ id: UUID) {
        guard !isNumberMatched(id) else { return }
        selectedNumberID = id
        selectedWordID = nil
        statusText = "Теперь выбери слово снизу."
    }

    func tapWord(_ id: UUID) {
        guard !isWordMatched(id) else { return }
        guard let nID = selectedNumberID else {
            statusText = "Сначала выбери число сверху."
            return
        }

        selectedWordID = id

        // Проверка правильности
        guard let numberItem = numbers.first(where: { $0.id == nID }),
              let wordItem = words.first(where: { $0.id == id }) else { return }

        if numberItem.value == wordItem.numberValue {
            matches.append(MatchPair(numberID: nID, wordID: id))
            ZZUser.shared.updateUserMoney(for: 10)
            statusText = matches.count == 3 ? "Отлично! Все пары соединены ✅" : "Верно! Продолжай."
        } else {
            statusText = "Неверно ❌ Попробуй другую корзину."
        }

        // Сбрасываем выбор, чтобы следующий ход начинался с числа
        selectedNumberID = nil
        selectedWordID = nil
    }

    func isNumberMatched(_ id: UUID) -> Bool {
        matches.contains(where: { $0.numberID == id })
    }

    func isWordMatched(_ id: UUID) -> Bool {
        matches.contains(where: { $0.wordID == id })
    }
}

// MARK: - Russian spelling 1...100

enum RussianNumberSpeller {
    static func spell(_ n: Int) -> String {
        precondition(1...100 ~= n)

        if n == 100 { return "сто" }

        let ones: [Int: String] = [
            1: "один", 2: "два", 3: "три", 4: "четыре", 5: "пять",
            6: "шесть", 7: "семь", 8: "восемь", 9: "девять"
        ]

        let teens: [Int: String] = [
            10: "десять", 11: "одиннадцать", 12: "двенадцать", 13: "тринадцать", 14: "четырнадцать",
            15: "пятнадцать", 16: "шестнадцать", 17: "семнадцать", 18: "восемнадцать", 19: "девятнадцать"
        ]

        let tens: [Int: String] = [
            2: "двадцать", 3: "тридцать", 4: "сорок", 5: "пятьдесят",
            6: "шестьдесят", 7: "семьдесят", 8: "восемьдесят", 9: "девяносто"
        ]

        if n < 10 { return ones[n] ?? "" }
        if 10...19 ~= n { return teens[n] ?? "" }

        let t = n / 10
        let o = n % 10

        if o == 0 { return tens[t] ?? "" }
        return "\(tens[t] ?? "") \(ones[o] ?? "")"
    }
}

enum EnglishNumberSpeller {
    static func spell(_ n: Int) -> String {
        precondition(1...100 ~= n)

        if n == 100 { return "one hundred" }

        let ones: [Int: String] = [
            1: "one", 2: "two", 3: "three", 4: "four", 5: "five",
            6: "six", 7: "seven", 8: "eight", 9: "nine"
        ]

        let teens: [Int: String] = [
            10: "ten", 11: "eleven", 12: "twelve", 13: "thirteen", 14: "fourteen",
            15: "fifteen", 16: "sixteen", 17: "seventeen", 18: "eighteen", 19: "nineteen"
        ]

        let tens: [Int: String] = [
            2: "twenty", 3: "thirty", 4: "forty", 5: "fifty",
            6: "sixty", 7: "seventy", 8: "eighty", 9: "ninety"
        ]

        if n < 10 { return ones[n] ?? "" }
        if 10...19 ~= n { return teens[n] ?? "" }

        let t = n / 10
        let o = n % 10

        if o == 0 { return tens[t] ?? "" }
        return "\(tens[t] ?? "")-\(ones[o] ?? "")"
    }
}
