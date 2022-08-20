//
//  RoundButton.swift
//  Calculator
//
//  Created by Rookedsysc on 2022. 8. 21..
//

import UIKit

// 변경된 설정값을 스토리보드 상에서 실시간으로 확인할 수 있게 해줌
@IBDesignable
class RoundButton: UIButton {
    // 스토리보드에서도 isRound 설정값을 변경할 수 있게 해줌
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                // 정사각형 버튼이 원이 되고 정사각형이 아닌 버튼들은 모서리가 둥글게 됨
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
