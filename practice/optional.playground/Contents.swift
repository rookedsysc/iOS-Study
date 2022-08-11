import UIKit

var number: Int? = 3
print(number)
print(number!) // 강제 해제 옵셔널 바인딩

// 비강제 옵셔널 바인딩
if let result = number {
    print(result)
} else {
    
}

func test() {
    let number: Int? = 5
    // if문으로 옵셔널 바인딩을 하면 옵셔널이 추출된 변수나 상수를 if문 안에서만 사용할 수 있지만 guard문으로 추출하게 되면 guard문 다음 함수 전체구문에서 해당 변수를 사용 가능
    guard let result = number else { return }
    print(result)
}

test()

let value: Int? = 6
if value == 6 {
    print("value가 6임")
} else {
    print("value가 6이 아님")
}

let string = "12"
var stringToInt: Int! = Int(string) // 묵시적 옵셔널 해제
print(stringToInt+1)
