//
//  SettingViewController.swift
//  LEDBoard
//
//  Created by Rookedsysc on 2022. 8. 20..
//

import UIKit

// Setting 값을 전달해주기 위해서 프로토콜 설정
protocol LEDBoardSettingDelegate: AnyObject {
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
}

class SettingViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var orangeButton: UIButton!
    
    // LEDBoardSettingDelegate 프로토콜을 delegate로 프로퍼티에 선언해줌
    weak var delegate: LEDBoardSettingDelegate?
    var textColor: UIColor = .yellow
    var backgroundColor: UIColor = .black
    var ledText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 
        self.configureView()
    }
    
    private func configureView() {
        if let ledText = self.ledText {
            self.textField.text = ledText
        }
        self.changeTextColor(color: self.textColor)
        self.changeBackgroundColorButton(color: self.backgroundColor)
    }
    
    @IBAction func tapTextColorButton(_ sender: UIButton) {
        // 노락색 버튼을 눌렷을 때
        if sender == self.yellowButton {
            self.changeTextColor(color: .yellow)
            self.textColor = .yellow
        } else if sender == self.greenButton {
            self.changeTextColor(color: .green)
            self.textColor = .green
        } else {
            self.changeTextColor(color: .purple)
            self.textColor = .purple
        }
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) {
        if sender == self.blackButton {
            self.changeBackgroundColorButton(color: .black)
            self.backgroundColor = .black
        } else if sender == self.blueButton {
            self.changeBackgroundColorButton(color: .blue)
            self.backgroundColor = .blue
        } else {
            self.changeBackgroundColorButton(color: .orange)
            self.backgroundColor = .orange
        }
    }
    
    private func changeTextColor(color: UIColor) {
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2
    }
    
    private func changeBackgroundColorButton(color: UIColor) {
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2
        self.blueButton.alpha = color == UIColor.blue ? 1 : 0.2
        self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        // 프로토콜 채택부의 changedSetting 함수로 값을 넘겨줘서 값을 바꿈(위임)
        self.delegate?.changedSetting(text: self.textField.text, textColor: self.textColor, backgroundColor: self.backgroundColor)
        self.navigationController?.popViewController(animated: true)
    }
}
