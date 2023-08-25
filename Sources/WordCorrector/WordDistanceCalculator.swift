import Foundation
import KoreanDecomposer

public enum WordDistanceCalculator {
    case jamo
    case character

    private static var maxDouble: Double { 999 }

    func calculate(word1: String, word2: String, debugMode: Bool = false) -> Double {
        switch self {
        case .character:
            return Self.levenshtein(word1, word2, isDebugMode: debugMode)
        case .jamo:
            return Self.jamoLevenshtein(between: word1, and: word2, isDebugMode: debugMode)
        }
    }

    public static func jamoLevenshtein(between word1: String, and word2: String, isDebugMode: Bool = false) -> Double {
        if word1.count < word2.count {
            return jamoLevenshtein(between: word2, and: word1, isDebugMode: isDebugMode)
        }

        if word2.isEmpty {
            return Double(word1.count)
        }

        var previousRow = Array(0...word2.count).map { Double($0) }
        for (i, character1) in word1.enumerated() {
            var currentRow = [Double(i)+1]
            for (j, character2) in word2.enumerated() {
                let insertions = previousRow[j+1] + 1
                let deletions = currentRow[j] + 1
                let substitutions = previousRow[j] + substitutionCostForJamoLevenshtein(character1, character2)
                currentRow.append(min(insertions, deletions, substitutions))
            }

            if isDebugMode {
                print(currentRow[1...].map { $0.roundAt(point: 2) })
            }

            previousRow = currentRow
        }

        return previousRow.last ?? 1.0
    }

    private static func substitutionCostForJamoLevenshtein(_ character1: Character, _ character2: Character) -> Double {
        if character1 == character2 { return 0 }
        guard let component1 = KoreanDecomposer.decompose(character1),
              let component2 = KoreanDecomposer.decompose(character2) else {
            return 999
        }
        return Double(levenshtein(component1, component2)) / 3
    }

    public struct CharacterPair: Hashable {
        let first: Character
        let second: Character
    }

    public typealias CostDictionary = [CharacterPair: Double]

    private static func levenshtein(_ word1: KoreanDecomposer.KoreanComponent, _ word2: KoreanDecomposer.KoreanComponent) -> Double {
        return zip(word1.asArray, word2.asArray).reduce(0) { partialResult, characters in
            let nextCost: Double = levenshtein(String(characters.0), String(characters.1))
            return partialResult + nextCost
        }
    }

    public static func levenshtein(_ word1: String, _ word2: String, cost: CostDictionary = CostDictionary(), isDebugMode: Bool = false) -> Double {
        if word1.count < word2.count {
            return levenshtein(word2, word1, isDebugMode: isDebugMode)
        }

        if word2.isEmpty {
            return Double(word1.count)
        }

        var previousRow = Array(0...word2.count).map { Double($0) }
        for (i, character1) in word1.enumerated() {
            var currentRow: [Double] = [Double(i) + 1]
            for (j, character2) in word2.enumerated() {
                let insertions = previousRow[j+1] + 1
                let deletions = currentRow[j] + 1
                let substitutions = previousRow[j] + substitutionCostForLevenshtein(first: character1, second: character2, in: cost)
                currentRow.append(min(insertions, deletions, substitutions))
            }

            if isDebugMode {
                print(currentRow[1...])
            }

            previousRow = currentRow
        }
        return previousRow.last ?? 1
    }

    private static func substitutionCostForLevenshtein(first character1: Character, second character2: Character, in costDictionary: CostDictionary) -> Double {
        if character1 == character2 { return 0 }
        return costDictionary[CharacterPair(first: character1, second: character2)] ?? 1
    }
}

fileprivate extension Double {
    func roundAt(point: Double) -> Double {
        let a = pow(10, point)
        return Foundation.round(self * a) / a
    }
}
