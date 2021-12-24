//
//  NewModuleProtocols.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/22.
//

import UIKit
import RxSwift

protocol NewViewControllerType: AnyObject {
    var presenter: NewPresenterType? { get }
    
    func drawView(with books: [BookInfo])
    func drawErrorView(with error: Error)
}

protocol NewInteractorType: AnyObject {
    var presenter: NewPresenterType? { get }
    var service: APIService { get }
    
    func fetchNewBooks() -> Observable<[BookInfo]>
}

protocol NewPresenterType: AnyObject {
    var view: NewViewControllerType? { get }
    var interactor: NewInteractorType? { get }
    var router: NewRouterType? { get }
    
    func prepareViewDidLoad()
    
    func didTapedBookCell(isbn13: String)
    func didTapedRetryButton()
}

protocol NewRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    func showDetail(isbn13: String)
}
