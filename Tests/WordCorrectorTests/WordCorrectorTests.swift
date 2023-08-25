import XCTest
@testable import WordCorrector

final class WordCorrectorTests: XCTestCase {
    var sut:WordCorrector!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dictionary =  [
            "후레쉬 베리", "초콜릿", "소시지", "약과", "오트밀 과자", "초코파이", "스키틀즈",
            "레몬 주스", "콜라", "초코 우유", "딸기 우유", "사이다", "사과 주스", "비타민", "식혜", "핫식스", "오렌지 에이드", "게토레이",
            "레쓰비", "아메리카노", "믹스 커피",
            "왕뚜껑", "육개장", "진라면", "튀김우동"
        ]
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

    func test_wordCorrector_3() throws {
        //Arrange
        let word = "학과"

        //Action
        let corrected = sut.correct(word: word)

        XCTAssertEqual(corrected, "약과")
    }

    func test_wordCorrector_4() throws {
        //Arrange
        let word = "토레이"

        //Action
        let corrected = sut.correct(word: word)

        XCTAssertEqual(corrected, "게토레이")
    }
    func test_wordCorrector_5() throws {
        //Arrange
        let word = "개 토레이"

        //Action
        let corrected = sut.correct(word: word)

        XCTAssertEqual(corrected, "게토레이")
    }
    func test_wordCorrector_6() throws {
        //Arrange
        let word = "식해"

        //Action
        let corrected = sut.correct(word: word)

        XCTAssertEqual(corrected, "식혜")
    }
}

