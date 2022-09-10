//
//  ViewController.swift
//  LEDBoard
//
//  Created by Rookedsysc on 2022. 8. 20..
//

import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate {
    @IBOutlet weak var contentsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 첫 세팅 값이 노란색이므로 노락색으로 지정
        self.contentsLabel.textColor = .yellow
    }
    
    // 오버라이드 + 다운캐스팅으로 SettingVeiwController에 직접 접근
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settingViewController = segue.destination as? SettingViewController {
            // Delegate를 통해 SettingVeiwController를 위임해줌
            settingViewController.delegate = self
            // 세팅 후 다시 세팅창에 들어갔을 시 세팅창이 초기화되지 않고 이전 세팅값을 가지고 있게끔 해주는 구문
            settingViewController.ledText = self.contentsLabel.text
            print(self.contentsLabel.text)
            print(settingViewController.ledText)
            settingViewController.textColor = self.contentsLabel.textColor
            settingViewController.backgroundColor = self.view.backgroundColor ?? .black
        }
    }
    // 프로토콜의 요구사항을 충족해줘야 함
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) {
        if let text = text {
            self.contentsLabel.text = text
        }
        self.contentsLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }
}

