//
//  SuguePresentViewController.swift
//  LEDElectronicDisplay
//
//  Created by Rookedsysc on 2022. 8. 18..
//

import UIKit

class SuguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
