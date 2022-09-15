//
//  CovidDetailTableViewController.swift
//  COVID-19
//
//  Created by Rookedsysc on 2022. 9. 15..
//

import UIKit

class CovidDetailTableViewController: UITableViewController {
    @IBOutlet weak var newCaseCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var recoveredCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var regionalOutBreakCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
