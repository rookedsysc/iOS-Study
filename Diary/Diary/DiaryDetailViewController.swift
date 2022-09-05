//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

class DiaryDetailViewController: UIViewController {
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    // 일기장 list 화면에서 일기장을 선택했을 때 diary 프로퍼티에 diary 객체를 넘겨주게 되면 일기장 상세화면에 일기장 제목, 내용, 날짜를 넘겨주게 됨
    private func configureView () {
        guard let diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date) //
    }
    
    /* 데이터 포매터 지정
     데이트 형식으로 넘겨주면 formatter.dateFormat에 지정한 형식의 String으로 반환함 */
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE요일)"
        return formatter.string(from: date)
    }
    
    @IBAction func tabEditButton(_ sender: UIButton) {
    }
    @IBAction func tabDeleteButton(_ sender: UIButton) {
    }
}
