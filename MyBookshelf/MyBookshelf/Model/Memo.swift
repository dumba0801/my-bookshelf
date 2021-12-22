//
//  Memo.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import RealmSwift

final class Memo: Object {
    @objc dynamic var isbn13: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var date: Date = Date()
}
