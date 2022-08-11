import UIKit

var greeting = "Hello, playground"

var dic1: Dictionary<String, Int> = Dictionary<String, Int>()
var dic2: [String: Int] = [:] // Dictio

dic2["김철수"] = 3 // dictionary 데이터 추가
dic2["김민지"] = 5 // dictionary 데이터 추가
dic2 // ["김민지": 5, "김철수": 3] 출력

dic2["김민지"] = 6 // 키 "김민지"의 값 변경
dic2 // ["김민지": 6, "김철수": 3]

dic2.removeValue(forKey: "김민지") // 김민지 키, 값 제거
dic2 // ["김철수": 3] 출력

var set: Set = Set<Int>()

set.insert(10)
set.insert(20)
set.insert(20) // 같은 값을 넣어도 오류는 출력되진 않지만 값은 1개만 들어가 있음
set // 10, 20 출력

set.remove(20) // set값 삭제
set // 10 출력
