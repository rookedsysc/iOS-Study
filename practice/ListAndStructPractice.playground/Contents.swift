import UIKit

struct UserInfoStruct {
    var name: String
    var phone: String
}

var users: [UserInfoStruct]

users = [UserInfoStruct.init(name: "성현", phone: "01012345678")]
users = [UserInfoStruct.init(name: "미애", phone: "01087654321")]

let names = ["wizplan", "eric", "yagom", "jenny"]

func backwards(first: String, second: String) -> Bool {
    print("\(first) \(second) 비교중")
    return first > second
}

let reversed: [String] = names.sorted(by: backwards)
print(reversed)

// 클로저를 이용한 backwards 함수 구현
let reversed_closure: [String] = names.sorted(
    by: { (first: String, second: String) -> Bool in return first > second
})
print(reversed_closure)

let reversedTraillingClosure: [String] = names.sorted() { (first: String, second: String) -> Bool in return first > second
}

print("reversedTraillingClosure result: \(reversedTraillingClosure)")

let reversedSkipInit: [String] = names.sorted {
    return $0 > $1
}

print("reversedSkipInit Result: \(reversedSkipInit)")

let reversedSkipReturn: [String] = names.sorted { $0 < $1 }

print("reversedSkipReturn result: \(reversedSkipReturn)")
