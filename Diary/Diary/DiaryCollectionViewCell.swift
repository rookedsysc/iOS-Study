//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

class DiaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // UIView가 xib나 storyboard에서 생성이 될 때 이 생성자를 통해 객체가 생성이 됨
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0 // 테두리 둥글게
        self.contentView.layer.borderWidth = 1.0 // 테두리 넓이
        self.contentView.layer.borderColor = UIColor.black.cgColor // 테두리 색
    }
}
