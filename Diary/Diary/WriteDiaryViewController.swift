//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

// 수정할 다이어리 객체를 전달 받을 프로퍼티
enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?
    var diaryEditorMode: DiaryEditorMode = .new // diary editor mode 타입을 저장하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.confirmButton.isEnabled = false // 등록버튼 비활성화
        self.configureEditMode() // 수정
    }
    
    // diaryEditorMode가 edit이라면 연관값으로 전달받은 데이터를 view에 초기화 시켜줌
    private func configureEditMode() {
        switch self.diaryEditorMode {
            case let .edit(_, diary) :
                self.titleTextField.text = diary.title
                self.contentsTextView.text = diary.contents
                self.dateTextField.text = self.dateToString(date: diary.date)
                self.diaryDate = diary.date
                self.confirmButton.title = "수정"
        default :
            break
        }
    
    }
    
    private func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE요일)"
        return formatter.string(from: date)
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged) // for: .text 입력될 때마다 호출
        self.dateTextField.addTarget(self, action: #selector(dateFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date // 날짜만 선택
        self.datePicker.preferredDatePickerStyle = .wheels
        
        // (target, selector, 어떤 이벤트가 발생했을 때 selector가 호출됨)
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        
        // self.datePicker.locale = Locale(identifier: "ko-KR") // 데이터 피커가 한국으로 표현되게 해줌, 근데 default가 한국어
        self.dateTextField.inputView = self.datePicker // 입력을 클릭했을 때 datePicker가 호출됨
    }
    private func configureContentsTextView() {
        // alpha 값은 투명도를 나타냄 (0.0 ~ 1.0) 0.0과 가까울수록 투명해짐
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        /* 레이어 관련된 색상을 설정할 때는 UI 컬러가 아닌 cg 컬러로 설정해야 함
         Text 필드의 테두리는 기본적으로 border(그림자)가 없기 때문에 이를 만들어줌*/
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    
@IBAction func tabConfirmButton(_ sender: Any) {
    guard let title = self.titleTextField.text else { return }
    guard let contents = self.contentsTextView.text else { return }
    guard let date = self.diaryDate else { return }
    
    switch self.diaryEditorMode {
    case .new : // case가 new라면 일기를 등록함
        let diary = Diary(
            uuidString: UUID().uuidString, // 일기를 생성할 때마다 고유한 uuid값을 지정해줌
            title: title,
            contents: contents,
            date: date,
            isStar: false)
        self.delegate?.didSelectRegister(diary: diary)
    case let .edit(indexPath, diary) :
        let diary = Diary(
            uuidString: diary.uuidString,
            title: title,
            contents: contents,
            date: date,
            isStar: diary.isStar)
        // 수정 버튼을 눌렀을 때 notificationCenter가 editDiary라는 notification key를 observing(관찰)하는 곳에 수정된 다이어리 객체를 전달하게 됨
        NotificationCenter.default.post(
            name: NSNotification.Name("editDiary"),
            object: diary,
            userInfo: nil
        )
    default:
        break
    }
    self.navigationController?.popViewController(animated: true)
}
    
    // 화면을 눌러줄 때 edit 상태에서 빠져나옴
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy년 MM월 dd일 (EEEEE요일)" // format 형식 정의 (****년 **월 **일(요일))
        formmater.locale = Locale(identifier: "ko_KR") // format local(언어) 정의
        self.diaryDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
        self.dateTextField.sendActions(for: .editingChanged)
         // 날짜가 변경될 때마다 dateTextFieldDidChange method 호출됨
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateFieldDidChange(_ textFiled: UITextField) {
        self.validateInputField()
    }
    
    private func validateInputField() {
        // 모든 필드가 비어있지 않으면 isEnabled
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    // TextView의 Text가 입력될 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        // TextField
        self.validateInputField()
    }
}
