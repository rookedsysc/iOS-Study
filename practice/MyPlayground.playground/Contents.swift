import UIKit

var greeting = "Hello, playground"

func sum(a: Int, b: Int) -> Int {
    return a+b
}

sum(a: 5, b: 3) // sum 함수 호출, 8출력

func hello() -> String {
    return "hello"
}

hello() // hello 출력

func greeting(friend: String, me: String = "gunter") { // 매개변수에 기본값 설정 (me에 gunter라는 값이 들어가 있음)
    print("hello, \(friend)! i'm \(me)")
}
greeting(friend: "Albert") // 기본값이 들어가 있는 me 변수에는 값을 지정해주지 않아도 됨
greeting(friend: "Albert", me: "백종인") // 기본값이 들어가 있는 변수의 값을 변경해줌

// 매개 변수가 없는 함수의 선언
func printName1() -> Void {
    
}
func printName2() {
    
}

// 전달인자 레이블을 사용하는 함수 선언
/*
 func 함수 이름([전달인자 레이블] [매개변수 이름]: 매개변수 타입, [전달인자 레이블] [매개변수 이름]: 매개변수 타입, ...) -> 반환 타입 {
    return 반환 값
 }
 */
func sendMessage(from myname: String, to name: String) -> String {
    return "Hello \(name)! I'm \(myname)"
}
sendMessage(from: "Gunter", to: "Json")
// 매개 변수의 역할을 좀 더 명확히 하게 해주기 위해 선언

// 와일드 카드 식별자 사용
func sendMessage2(_ name:String) -> String {
    return "Hello \(name)"
}

sendMessage2("Gunter")

// 가변 매개변수
func sendMessage3(me: String, friends: String...) -> String {
    return "Hello \(friends)! I'm \(me)"
}
sendMessage3(me: "Gunter", friends: "Json", "Albert", "Stella") // 가변 매개변수에는 다수의 값을 넣을 수 있음 (리스트로 저장)
// 출력값 : "Hello ["Json", "Albert", "Stella"]! I'm Gunter"
