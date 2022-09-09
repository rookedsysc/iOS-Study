//
//  StarCollectionViewCell.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import UIKit

class StarCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // collection view cell 테두리 만들기
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
