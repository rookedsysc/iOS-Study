//
//  ViewController.swift
//  LEDElectronicDisplay
//
//  Created by Rookedsysc on 2022. 8. 18..
//

import UIKit

// SendDataDelegate 프로토콜 채택
class ViewController: UIViewController, SendDataDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SeguePushViewController {
            viewController.name = "Gunter"
        }
    }
    @IBAction func tapCodePushButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CodePushViewController") as? CodePushViewController else { return }
        viewController.name = "Gunter"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapCodePresentButton(_ sender: UIButton) {
        // 스토리보드의 뷰 컨트롤러를 인스턴트화 시켜줘야 함
        // indentifier에는 스토리보드 상에서 정의한 storyboardID를 넘겨줌
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else { return }
        viewController.name = "Gunter"
        // Present View 풀스크린으로 실행
        viewController.modalPresentationStyle = .fullScreen
        // self로 초기화를 하게 되면 프로토콜을 위임 받음
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sendData(name: String) {
        self.nameLabel.text = name
        // Label
        self.nameLabel.sizeToFit()
    }
    
}

