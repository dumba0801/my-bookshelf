//
//  MemoInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import Foundation
import RealmSwift

final class MemoInteractor {
    weak var presenter: MemoPresenterType?
    let isbn13: String
    
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
}

extension MemoInteractor: MemoInteractorType {
    func saveMemo(title: String, body: String) {
        guard let presenter = self.presenter else { return }
        
        let memo = Memo()
        memo.isbn13 = self.isbn13
        memo.title = title
        memo.body = body
        
        do {
            let realm = try Realm()
            
            try realm.write{
                realm.add(memo)
            }
        } catch let error {
            print(error)
        }
        
        presenter.dismiss()
    }
}
