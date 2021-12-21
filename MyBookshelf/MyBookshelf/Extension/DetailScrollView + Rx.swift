//
//  DetailScrollView + Rx.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/19.
//

import RxSwift

extension Reactive where Base: DetailScrollView {
    var book: Binder<DetailBook?> {
        return Binder(self.base) { view, book in
            view.book = book
        }
    }
}
