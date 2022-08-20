//
//  CodePushViewController.swift
//  LEDElectronicDisplay
//
//  Created by Rookedsysc on 2022. 8. 18..
//

import UIKit

class CodePushViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            // 글자가 안짤려서 나오게 해줌
            self.nameLabel.sizeToFit()
        }

    }
    
    @IBAction func BackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
