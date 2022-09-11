//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

protocol DiaryDetailVeiwDelegate: AnyObject {
    // func didSelectDelete(indexPath: IndexPath)
    // func didSelectStar(indexPath: IndexPath, isStar: Bool)
}

class DiaryDetailViewController: UIViewController {
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var starButton: UIBarButtonItem?
    
    weak var delegate: DiaryDetailVeiwDelegate?
    
    var diary: Diary?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        // Detail View간 즐겨찾기 싱크 맞추기
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
    }
    
    // 일기장 list 화면에서 일기장을 선택했을 때 diary 프로퍼티에 diary 객체를 넘겨주게 되면 일기장 상세화면에 일기장 제목, 내용, 날짜를 넘겨주게 됨
    private func configureView () {
        guard var diary = self.diary else { return }
        self.titleLabel.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLabel.text = self.dateToString(date: diary.date)
        
        // 즐겨찾기 버튼 활성화
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tabStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star") // isStar true면 꽉찬 별, false면 테두리만 있는 별
        self.starButton?.tintColor = .orange // 오렌지색으로 설정
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    // Star Button을 눌렀을 때 호출되는 Selector
    @objc func tabStarButton() {
        guard let isStar = self.diary?.isStar else { return } 

        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        NotificationCenter.default.post(name: NSNotification.Name("starDiary"), object: [
            "diary": self.diary, 
            "isStar": self.diary?.isStar,
            "uuidString": self.diary?.uuidString
        ], userInfo: nil
        )
    }
    
    /* 데이터 포매터 지정
     데이트 형식으로 넘겨주면 formatter.dateFormat에 지정한 형식의 String으로 반환함 */
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE요일)"
        return formatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        // 포스트에서 보낸 수정된 Diary 객체를 가져오는 객체
        guard let diary = notification.object as? Diary else { return }
 
        self.diary = diary // 전달받은 수정된 다이어리 객체를 전달해줌
        self.configureView() // 수정된 내용으로 view가 update되게 configureView 호출
    }
    
    /* 일기장 탭과 즐겨찾기 탭에서 같은 일기를 클릭해서 detail view로 들어갔을 때,
     일기장 탭의 detail view에서 즐겨찾기를 해제해도 즐겨찾기 tab의 detail view에서는 즐겨찾기 등록 상태임
     이 현상의 싱크를 맞추기 위해서 사용된 구문 */
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        
        if diary.uuidString == uuidString {
            
            self.diary?.isStar = isStar
            self.configureView()
        }
    }
    
    @IBAction func tabEditButton(_ sender: UIButton) {
        // 수정 버튼을 누르면 WriteDiaryViewController가 Push되게 함
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        // diaryEditorMode에 열거형 edit을 전달하게 되고 연관 값으로 index Path와 diary 객체를 전달해줌
        viewController.diaryEditorMode = .edit(indexPath, diary)
        
        /* 수정 버튼을 눌렀을 때 editDiaryNotification을 관찰하는 옵저버가 추가되고
        WirteDiaryViewController를 통해서 수정된 Diary 객체가 NotificationCenter를 통해서 포스트될 때
         editDiaryNotificationCenter가 호출됨 */
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tabDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        // self.delegate?.didSelectDelete(indexPath: indexPath)
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object: uuidString,
            userInfo: nil
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    // 인스턴스가 deinit될 때 NotificationCenter removeObserver를 호출해서 해당 인스턴스에 호출된 obeserver가 모두 제거됨
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
