import XCTest
@testable import WordCorrector

final class WordCorrectorTests: XCTestCase {
    var sut:WordCorrector!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dictionary = ["새우깡", "초콜릿", "후레쉬베리"]
        sut = WordCorrector(wordDictionary: dictionary)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_levenshtein() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WordDistanceCalculator.levenshtein("일이삼", "아이오아이"), 4)
    }

    func test_jamoLevenshtein_1() throws {
        XCTAssertEqual(WordDistanceCalculator.jamoLevenshtein(between: "새우까", and: "새우깡"), 1/3)
    }

    func test_jamoLevenshtein_2() throws {
        XCTAssertEqual(WordDistanceCalculator.jamoLevenshtein(between: "새우가", and: "새우깡"), 2/3)
    }

    func test_jamoLevenshtein_3() throws {
        XCTAssertEqual(WordDistanceCalculator.jamoLevenshtein(between: "개우가", and: "새우깡"), 1)
    }

    func test_jamoLevenshtein_4() throws {
        XCTAssertEqual(WordDistanceCalculator.jamoLevenshtein(between: "개우가나", and: "새우깡"), 2)
    }

    func test_wordCorrector() throws {
        //Arrange
        let word = "새우강"

        //Action
        let corrected = sut.correct(word: word)

        XCTAssertEqual(corrected, "새우깡")
    }
}
