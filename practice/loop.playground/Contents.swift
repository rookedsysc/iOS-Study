import UIKit

var greeting = "Hello, playground"


/*
 for 루프상수 in 순회대상 {
        // 실행할 구문
 }
 */
for i in 1...10 {
    print(i)
}
let array1 = [1,2,3,4,5]
for i in array1 {
    print(i)
}

/*
 while 조건식 {
    // 실행할 구문
 */
var number = 5

while number < 10 {
    number += 1
}

/*
 repeat {
    // 실행할 구문
 } while 조건식
 */
var x = 6

repeat {
    x+=2

} while x < 5
print(x) // 8출력 because 6인 상태에서 repeat이 한 번 더 실행되기 때문
