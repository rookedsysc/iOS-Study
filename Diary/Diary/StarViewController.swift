//
//  StarViewController.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

class StarViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList  = [Diary]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadStarDiaryList()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }
    
    private func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일 (EEEEE요일)"
        return formatter.string(from: date)
    }
    
    // collectionView의 속성 설정
    private func configureCollectionView() {
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    // 즐겨찾기가 된 일기만 가져옴
    private func loadStarDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        self.diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }.filter({
            $0.isStar == true
        }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending // 날짜 시간순으로 정렬
        })
        self.collectionView.reloadData()
    }
}

extension StarViewController: UICollectionViewDataSource {
    // 즐겨찾기 된 다이어리 list 배열의 개수만큼 셀이 표시됨
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarCollectionViewCell", for: indexPath) as? StarCollectionViewCell else { return UICollectionViewCell() } // 다운캐스팅에 실패하면 빈 UICollectionView 호출
        let diary = self.diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = self.dateToString(date: diary.date)
        return cell
    }
}

// CollectionView Layout 구성
extension StarViewController: UICollectionViewDelegateFlowLayout {
    // 즐겨찾기 목록은 리스트 형식으로 보여줄거라 width 값을 화면 좌우 간격에 꽉 채우고 - constrain에서 설정한 값을 해줌
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}
