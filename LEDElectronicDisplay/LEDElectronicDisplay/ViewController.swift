//
//  ViewController.swift
//  LEDElectronicDisplay
//
//  Created by Rookedsysc on 2022. 8. 18..
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func tapCodePushButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "CodePushViewController") else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapCodePresentButton(_ sender: UIButton) {
        guard let viewConroller = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") else { return }
        
        self.present(viewConroller, animated: true, completion: nil)
        
        // Present View 풀스크린으로 실행
        viewConroller.modalPresentationStyle = .fullScreen
    }
    
}

