//
//  MemoPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import Foundation

protocol MemoPresenterType: AnyObject {
    
}

final class MemoPresenter {
    var router: MemoRouterType?
    var interactor: MemoInteractorType?
    weak var view: MemoViewType?
}

extension MemoPresenter: MemoPresenterType {
    
}
