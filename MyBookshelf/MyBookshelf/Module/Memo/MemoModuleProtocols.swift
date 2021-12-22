//
//  MemoModuleProtocols.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/22.
//

import UIKit

protocol MemoViewType: AnyObject {
    var presenter: MemoPresenterType? { get }
}

protocol MemoInteractorType: AnyObject {
    var presenter: MemoPresenterType? { get }
    var isbn13: String { get }
    
    func saveMemo(title: String, body: String)
}

protocol MemoPresenterType: AnyObject {
    var view: MemoViewType? { get }
    var interactor: MemoInteractorType? { get }
    var router: MemoRouterType? { get }
    
    func saveMemo(title: String?, body: String?)
    func dismiss()
}

protocol MemoRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func dismiss()
}
