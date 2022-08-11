import UIKit
import Darwin

var greeting = "Hello, playground"

// 구조체나 클래스의 이름은 대문자로 시작함
struct Users {
    var nickname: String
    var age: Int
    
    func information () {
        print("\(nickname) \(age)")
    }
}

var user = Users(nickname: "Gunter", age: 23)

user.nickname
user.nickname = "Albert"
user.nickname

user.information()
