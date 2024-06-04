# WordCorrector

특정 단어와 주어진 dictionary set 안에서 가장 유사한 단어를 알려줍니다.

## Installation 
To install this package, import https://github.com/vanism2091/WordCorrector in SPM.

## Usage Example
```swift
let dictionary = [..., "게토레이",...]
let corrector = WordCorrector(wordDictionary: dictionary)

let word = "개 토레이"
let corrected = corrector.correct(word: word)
print(corrector) // "게토레이"
```

## References
https://lovit.github.io/nlp/2018/08/28/levenshtein_hangle/
