//
//  DetailScrollView + Rx.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/19.
//

import RxSwift
import RxCocoa

extension Reactive where Base: DetailScrollView {
    var book: Binder<DetailBook?> {
        return Binder(self.base) { view, book in
            view.book = book
        }
    }
    
    var addMemo: ControlEvent<Void> {
        base.addMemoButton.rx.tap
    }
    
    var memos: Binder<[Memo]> {
        return Binder(self.base) { view, memos in
            view.memos = memos
        }
    }
}
