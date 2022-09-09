//
//  Diary.swift
//  Diary
//
//  Created by Rookedsysc on 2022. 9. 4..
//

import Foundation

struct Diary {
    var uuidString: String // 일기를 생성할 때마다 고유한 uuid값을 넣어주게 됨
    var title: String
    var contents: String
    var date: Date
    var isStar: Bool
}
