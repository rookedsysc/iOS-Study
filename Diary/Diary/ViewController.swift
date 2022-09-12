//
//  ViewController.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            // diaryList가 변경될 때마다 saveDiaryList 호출
            self.saveDiaryList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.loadDiaryList()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: NSNotification.Name("editDiary"),
                                               object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deleteDiaryNotification(_:)),
            name: NSNotification.Name("deleteDiary"),
            object: nil
        )
    }
    
    // UserDefaults를 이용해서 앱을 재실행해도 등록한 일기가 사라지지 않게 함
    private func saveDiaryList() {
        let data = self.diaryList.map {
            [
                "uuidString": $0.uuidString,
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard // UserDefaults에 접근권한 설정
        /*
         data 형식이 Dictionary 형식, forkey에 있는 key를 dictionary 형태로 set(저장)해줌
         */
        userDefaults.set(data, forKey: "diaryList")
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(uuidString: uuidString, title: title, contents: contents, date: date, isStar: isStar)
            
        }
        self.diaryList = self.diaryList.sorted(by: {$0.date.compare($1.date) == .orderedDescending}) // 내림차순 정렬(최신순)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return } // 전달받은 Diary 객체 가져옴
        // notification에서 전달 받은 요소와 배열에 같은 값이 있는지 확인하고 있으면 해당 요소의 인덱스 값을 return 해줌
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
         
        self.diaryList[index] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        }) // 날짜가 변경될 수 있으므로 한 번 더 정렬
        self.collectionView.reloadData() // collectionView에 reload 해줌
    }
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList[index].isStar = isStar
    }
    @objc func deleteDiaryNotification(_ notification: Notification) {
        guard let uuidString = notification.object as? String else { return }
        guard let index = self.diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        self.diaryList.remove(at: index)
        self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        // Collection View에 표시되는 Contents의 좌, 우, 위, 아래 간격
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    // WriteDidaryVC에서 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 세그웨이로 이동되는 View Controller 지정
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self // delegate 위임 받음
        }
    }
    
    // 데이터 포매터 지정
    private func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE요일)"
        return formatter.string(from: date)
    }
}

// WriteDidaryVC에서 데이터 전달
extension ViewController: UICollectionViewDataSource {
    // 표시할 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    // Collection View의 지정된 위치에 표시할 cell을 요청하는 메서드, Table View의 CellForRowAt과 비슷함
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCollectionViewCell else { return UICollectionViewCell() }
        let diary = self.diaryList[indexPath.row] // 배열에 저장되있는 일기를 가져옴
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

// WriteDidaryVC에서 데이터 전달
extension ViewController: UICollectionViewDelegateFlowLayout {
    // Cell의 사이즈를 설정함, cgSize 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 아이폰 화면의 너비값 / 2 - Contetns inset의 left/right 값인 20 만큼 빼줌
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

extension ViewController: WriteDiaryViewDelegate {
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        // 일기를 추가할 때마다 Collection View를 reload 시켜줌
        self.diaryList = self.diaryList.sorted(by: {$0.date.compare($1.date) == .orderedDescending}) // 내림차순 정렬(최신순)
        self.collectionView.reloadData()
    }
}

// diary detail view controller가 push 되게 함
extension ViewController: UICollectionViewDelegate {
    // 특정 cell이 선택됐음을 알려주는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row] // 선택된 인덱스가 뭔지 넘겨줌
        viewController.diary = diary
        viewController.indexPath = indexPath
        // viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

/*
// 삭제 버튼
extension ViewController: DiaryDetailVeiwDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }

    // 즐겨찾기 여부 업데이트
    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
        self.diaryList[indexPath.row].isStar = isStar
    }
}
 */
