import KoreanDecomposer
import Foundation

public struct WordCorrector {
    public private(set) var wordDictionary: [String]
    var calculator: WordDistanceCalculator = .jamo

    public func correct(word: String, threshold: Double = 10) -> String? {
        let map = correctMap(of: word)
        guard let first = map.first,
              first.1 < threshold else { return nil }
        return first.0
    }

    public func correctMap(of word: String) -> [(String, Double)] {
        wordDictionary.map { wordInDictionary in
            // calculator가 .character인 경우 as Double이 안돼서 cost가 의도와 다르게 나올 수도 있음..
            let cost = calculator.calculate(word1: word, word2: wordInDictionary, debugMode: false)
            return (wordInDictionary, cost)
        }.sorted { $0.1 < $1.1 }
    }

    mutating func changeCalculator(to calculator: WordDistanceCalculator) {
        self.calculator = calculator
    }
}
