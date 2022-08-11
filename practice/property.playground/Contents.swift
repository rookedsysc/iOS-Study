import UIKit

struct Dog {
    var name: String // 저장 프로퍼티
    let gender: String
}

var dog = Dog(name: "Gunter", gender: "Male")
print(dog)

dog.name = "권태완"
// dog.gender = "female" // 에러 발생 상수로 선언되었기 때문에 변경 불가능

let dog2 = Dog(name: "Gunter", gender: "male")
// dog2.name = "권태완" // 구조체의 프로퍼티가 변수여도 인스턴스 자체가 상수이기 때문에 값을 변경할 수 없음

// 클래스는 참조타입이기 때문에 상수 인스턴스의 프로퍼티의 값도 변경 가능
class Cat {
    var name: String
    let gender: String
    
    init(name: String, gender: String) {
        self.name = name
        self.gender = gender
    }
}

let cat = Cat(name: "json", gender: "male")
// 클래스는 참조타입이기 때문에 상수 인스턴스의 프로퍼티의 값도 변경 가능
cat.name = "Gunter"
print(cat.name)


struct Stock {
    var averagePrice: Int // 평단가
    var quantity: Int // 주식수
    // 계산 프로퍼티
    // get, set 등을 이용해서 값을 연산하고 프로퍼티에 저장해주는 것을 계산 프로퍼티라 함
    var purchasePrice:
    {
        get {
            return averagePrice * quantity
        }
        // set의 프로퍼티 이름을 지정해주지 않으면 newValue로 자동 지정됨
        set(newPrice) {
            averagePrice = newPrice / quantity
        }
    }
}

var stock = Stock(averagePrice: 2300, quantity: 3)
print(stock)
stock.purchasePrice
// 계산 프로퍼티에 값을 넣으면 set 구문에 들어가서 값을 계산해줌
stock.purchasePrice = 3000
stock.averagePrice // 1000 출력


// 프로퍼티 옵저버
class Account {
    var credit: Int = 0 {
        // 값이 저장되기 직전에 호출됨, newValue가 기본값으로 지정되어 있으며 newValue는 상수
        willSet {
            print("잔액이 \(credit) 원에서 \(newValue)원으로 변경될 예정입니다.")
        }
        // 값이 저장된 직후에 호출함, oldValue가 기본값으로 지정되있음
        didSet{
            print("잔액이 \(oldValue)원에서 \(credit)원으로 변경되었습니다.")
        }
    }
}

var account = Account()
account.credit = 1000

// 타입 프로퍼티
// 인스턴스 생성 없이 객체 내의 프로퍼티에 접근이 가능하게 하는 것
// 저장 프로퍼티와 연산 프로퍼티에서만 사용가능
// static 키워드를 사용해서 정의함
struct SomeStructure {
    static var storedTypeProperty = "Some value." // 스토어
    static var computedTypeProperty: Int { // 컴퓨티드
        return 1
    }
}
// 인스턴스를 할당해주지 않고도 프로퍼티 값에 접근 가능
SomeStructure.storedTypeProperty = "Hello"
SomeStructure.storedTypeProperty
