import UIKit

var greeting = "Hello, playground"

/*
if 조건식 {
 실행할 구문
 }
 */

let age = 12

if age < 19 {
    print("미성년자 입니다")
}

/*
 if 조건식 {
 조건식 만족하면 해당 구문 실행
 } else {
 조건 만족하지 않으면 해당 구문 실행
 }
 */

if age < 19 {
    print("미성년자")
} else {
    print("성년자")
}

/*
if 조건식1 {
 // 조건식1 만족시 실행할 구문
 } else if 조건식 2 {
 조건식2 만족시 실행할 구문
} else {
 조건식 모두 만족하지 않을시 실행할 구문
 }
 */

var animal = "pig"

if animal == "dog" {
    print("강아지 사료 주기")
} else if animal == "cat" {
    print("고양이 사료주기")
} else {
    print("굶어")
}


/*
 switch 비교대상 {
    case 패턴1 :
        // 패턴1 일치할 때 실행되는 구문
    case 패턴2, 패턴3 :
        // 패턴2, 3이(AND) 일치할 때 실행되는 구문
    default :
        // 어느 패턴도 일치하지 않을 때 실행되는 구문
 */ // 하나의 패턴 일치시 Switch 구문은 종료가 됨

var color = "green"
switch color {
case "blue":
    print("파란색 입니다")
case "green":
    print("초록색 입니다")
default :
    print("찾는 색상이 없습니다")
} // 초록색 입니다 출력

let temperature = 30
switch temperature {
case -20...9 :
    print("겨울")
case 10...14 :
    print("가을")
case 15...25 :
    print("봄")
case 26...35 :
    print("여름")
default:
    print("이상기후")
} // 여름 출력
