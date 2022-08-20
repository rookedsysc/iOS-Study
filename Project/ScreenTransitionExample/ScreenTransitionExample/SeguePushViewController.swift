//
//  SeguePushViewController.swift
//  LEDElectronicDisplay
//
//  Created by Rookedsysc on 2022. 8. 18..
//

import UIKit

class SeguePushViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        // rootViewController로 이동되게 함
        // self.navigationController?.popToRootViewController(animated: true)
        
    }
}
