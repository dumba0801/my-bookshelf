//
//  MemoPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import Foundation

final class MemoPresenter {
    var router: MemoRouterType?
    var interactor: MemoInteractorType?
    weak var view: MemoViewType?
}

extension MemoPresenter: MemoPresenterType {
    func saveMemo(title: String?, body: String?) {
        guard
            let title = title,
            let body = body,
            let interactor = self.interactor
        else {
            return
        }
        
        interactor.saveMemo(title: title, body: body)
        
    }
    
    func dismiss() {
        guard let router = self.router else { return }
        router.dismiss()
    }
}
