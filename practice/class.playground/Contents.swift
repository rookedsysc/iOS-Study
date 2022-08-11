
import UIKit

class User {
    var nickname: String
    var age: Int
    
    init(nickname: String, age: Int) {
        self.nickname = nickname
        self.age = age
    }
    // 초기값을 설정해 줄 수 있음
    init(age: Int) {
        self.nickname = "albert"
        self.age = age
    }
  
}

var user3: User? = User(age: 23)
// 스위프트는 인스턴스가 더 이상 필요하지 않으면 자동으로 메모리에 소멸시킴, user3에 nil을 대입시키면 인스턴스가 더 이상 필요하지 않다고 판단해 deinit이 실행됨
user3 = nil
