//
//  CodePresentViewController.swift
//  LEDElectronicDisplay
//
//  Created by Rookedsysc on 2022. 8. 18..
//

import UIKit

protocol SendDataDelegate: AnyObject{
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    // delegate 패턴을 사용할 때 메모리 누수 방지를 위해서 weak 키워드를 붙여줘야 함
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 옵셔널 바인딩으로 name 값에 들어온 값 추출해서 Outlet 변수 nameLabel의 text property에 넣어줌
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    @IBAction func tapBackButton(_ sender: UIButton) {
        /* 데이터를 전달받은 뷰컨트롤러에서 Send*/
        self.delegate?.sendData(name: "Gunter")
        self.presentingViewController?.dismiss(animated: true)
    }
    

}
