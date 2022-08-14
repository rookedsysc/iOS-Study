import UIKit

/*
// 클래스 상속받는 방법
class 클래스 이름: 부모클래스 이름 {
    // 하위 클래스 정의
}
*/
class Vehicle {
    var currentSpeeed = 0.0
    var descriptiton: String {
        return "traveling at \(currentSpeeed) miled per hour"
        
    }
    func makeNoise() {
    }
}


class Bicycle: Vehicle {
    var hasBasket = false
    
}

var bicycle = Bicycle()
// 상속받은 클래스의 프로퍼티에 접근 가능
bicycle.currentSpeeed
bicycle.currentSpeeed = 15.0
bicycle.currentSpeeed

// 서브 클래스는 슈퍼 클래스에서 정의된 메소드, 프로퍼티, 서브스크립 등을 그대로 사용하지 않고 자신만의 기능으로 만들어서 사용이 가능함, 이를 오버라이딩이라고 함
// overide


