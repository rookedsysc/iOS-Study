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
    
    // 이 프로퍼티로 선택된 지억의 코로나 발생 현황 데이터를 받음
    var covidOverview: CovidOverview?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName // 지역 이름
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase) 명" // 신규 확진자
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase) 명" // 전체 확진자
        self.recoveredCell.detailTextLabel?.text = "\(covidOverview.recovered) 명" // 완치자 수
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death) 명" // 사망자 수
        self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage) %"
        self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newFcase) 명"
        self.regionalOutBreakCell.detailTextLabel?.text = "\(covidOverview.newCcase) 명"
    }
}
