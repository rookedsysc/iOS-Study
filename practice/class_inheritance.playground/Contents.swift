import UIKit

/*
// 클래스 상속받는 방법
class 클래스 이름: 부모클래스 이름 {
    // 하위 클래스 정의
}
*/
class Vehicle {
    var currentSpeed = 0.0
    var descriptiton: String {
        return "traveling at \(currentSpeed) miled per hour"
        
    }
    func makeNoise() {
        print("speaker on")
    }
}

class Bicycle: Vehicle {
    var hasBasket = false
}

var bicycle = Bicycle()
// 상속받은 클래스의 프로퍼티에 접근 가능
bicycle.currentSpeed // 0 출력
bicycle.currentSpeed = 15.0
bicycle.currentSpeed // 15 출력

// 서브 클래스는 슈퍼 클래스에서 정의된 메소드, 프로퍼티, 서브스크립 등을 그대로 사용하지 않고 자신만의 기능으로 만들어서 사용이 가능함, 이를 오버라이딩이라고 함

class Train: Vehicle {
    override func makeNoise() {
        // 슈퍼 클래스에 정의뙨 makeNoise 메서드를 먼저 호출함
        super.makeNoise()
        print("choo choo")
    }
}

let train = Train()
train.makeNoise()

class Car: Vehicle {
    var gear = 1
    override var descriptiton: String {
        return super.descriptiton + " in gear \(gear)"
    }
}
let car = Car()
car.currentSpeed = 30.0
car.gear = 2
print(car.descriptiton)

// 상속받은 프로퍼티에서 옵저버 사용
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10) + 1
        }
    }
}

let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.descriptiton)")

final class Vehicle1 {
    final var currentSpeed = 0.0
    var descriptiton: String {
        return "traveling at \(currentSpeed) miled per hour"
        
    }
    func makeNoise() {
        print("speaker on")
    }
}
