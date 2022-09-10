//
//  ViewController.swift
//  Calculator
//
//  Created by Rookedsysc on 2022. 8. 21..
//

import UIKit

enum Operation {
    case Add
    case Subtract
    case Divide
    case Multiply
    case Unknown
}

class ViewController: UIViewController {
    @IBOutlet weak var numberOutputLabel: UILabel!
    
    // 계산기 버튼을 누를 때 마다 numberOutputLabel 표시될 값을 담고 있는 프로퍼티
    var displayNumber = ""
    // 이전 계산 값을 저장하는 프로퍼티(첫 번째 피연산자)
    var firstOperand = ""
    // 새롭게 입력된 값을 저장하는 프로퍼티(두 번째 피연산자
    var secondOperand = ""
    // 계산의 결과 값을 저장하는 프로퍼티
    var result = ""
    // 현재 계산기에 어떤 연산자가 입력되었는지 알 수 있게 연산자의 값을 저장하는 프로퍼티
    var currentOperation: Operation = .Unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapBumberNutton(_ sender: UIButton) {
        // sender에 입력된 button의 타이틀 값을 받아옴 이 때, title값은 optional 값임
        // 기존에 sender.title(for: .normal) 방식으로 타이틀 값을 받아오니 nil 이 반환되어서 대체해 줌
        guard let numberValue = sender.titleLabel?.text else { return }
        // displayNumber를 9개 미만으로만 받아줌 (9자리까지 입력 가능 < 9개일 때 못 들어와서 10개까지 입력이 안됨)
        if  self.displayNumber.count < 9 {
            self.displayNumber += numberValue
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    func operation(_ operation: Operation) {
        if self.currentOperation != .Unknown {
            if !self.displayNumber.isEmpty {
                // 입력된 opration이 있고 첫 번째 피연산자가 있는 상태이므로 현재 입력된 값을 두 번째 피연산자에 넣어줌
                self.secondOperand = self.displayNumber
                self.displayNumber = ""
                
                // opration 값이 문자형이기 때문에 Double 형으로 변환
                guard let firstOprand = Double(self.firstOperand) else { return }
                guard let secondOperand = Double(secondOperand) else { return }
                
                // switch문에 따라서 해당되는 opration 수행하고 reusult 값에 저장
                switch self.currentOperation {
                case .Add :
                    self.result = "\(firstOprand + secondOperand)"
                case .Subtract :
                    self.result = "\(firstOprand - secondOperand)"
                case .Divide :
                    self.result = "\(firstOprand / secondOperand)"
                case .Multiply :
                    self.result = "\(firstOprand * secondOperand)"
                default :
                    break
                }
                // reuslt를 1로 나눈 값이 0이라면 Int 타입으로 변환해서 소수점을 지워줌
                if let  result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))"
                }
                // 연산의 결과값을 다시 첫 번째 피연산자에 넣어서 다음 연산에 사용할 수 있게 해줌
                self.firstOperand = self.result
                // 결과값을 라벨에 출력해줌
                self.numberOutputLabel.text = self.result
            }
            
            // opration을 연속해서 입력했을 경우를 위해 opration 값을 다시 넣어줌
            self.currentOperation = operation
        
        // 처음에 연산버튼을 누르면 currentOperation 값이 .Unknown이어서 else문 동작
        } else {
            // firstOperand에 현재 display 되고 있는 숫자(방금 입력한 넘버 넣어줌)
            self.firstOperand = self.displayNumber
            // currentOperation에 방금 입력한 opration 넘겨줌
            self.currentOperation = operation
            // operation을 선택하면 display 되는 숫자가 사라짐
            self.displayNumber = ""
        }
    }
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    @IBAction func tapSubtractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    @IBAction func tapMultiplyButton(_ sender: UIButton) {
        self.operation(.Multiply)
    }
    @IBAction func tapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
        
    }
    
    // = 버튼을 누르면 opration 함수의
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(self.currentOperation)
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        
        // displayNumber 문자열에 "."이 중복으로 표현 되는지 확인
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            // displayNumber가 비어있다면 즉, 숫자가 아무것도 입력되지 않은 상태라면 0. 으로 입력되게 해줌
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = displayNumber
        } else {
            print("if문 충족하지 않음")
        }
    }
    // 초기화 버튼
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .Unknown
        self.numberOutputLabel.text = "0"
    }

}

