//
//  ViewController.swift
//  DatePickerExample
//
//  Created by Rookedsysc on 2022. 9. 12..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var storyBoardDatePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    // datePicker 저장
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDatePicker()
        self.configureStoryBoardDatePicker()
    }
    
    func configureStoryBoardDatePicker() {
        self.storyBoardDatePicker.preferredDatePickerStyle = .compact
        self.storyBoardDatePicker.datePickerMode = .date
        
        self.storyBoardDatePicker.addTarget(self, action: #selector(storyboardDatePickerValueDidChange), for: .valueChanged)
    }
    
    @objc func storyboardDatePickerValueDidChange(_ datePicker: UIDatePicker) {
        guard let chooseDate = datePicker.date as? Date else { return }
        self.dateLabel.text = dateToString(date: chooseDate)
        print(dateToString(date: chooseDate))
    }

    func configureDatePicker() {
        self.datePicker.datePickerMode = .date // 날짜만 선택
        self.datePicker.preferredDatePickerStyle = .wheels
        
        // (target, selector, 어떤 이벤트가 발생했을 때 selector가 호출됨)
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        self.datePicker.locale = Locale(identifier: "ko-KR") // 데이터 피커가 한국으로 표현되게 해줌
        self.dateTextField.inputView = self.datePicker // 입력을 클릭했을 때 datePicker가 호출됨
    }
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        guard let chooseDate = datePicker.date as? Date else { return }
        self.dateTextField.text = self.dateToString(date: chooseDate)
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE요일)"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }

}

