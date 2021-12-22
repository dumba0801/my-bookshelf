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
    func onFetchedNewBooks(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
}

protocol NewInteractorType: AnyObject {
    var presenter: NewPresenterType? { get }
    var service: APIService { get }
    func fetchNewBooks()
}

protocol NewPresenterType: AnyObject {
    var interactor: NewInteractorType? { get }
    func fetchNewBooks(subject: Observable<Void>)
    func showDetail(isbn13: String)
    func onFetchedNewBooks(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
}

protocol NewRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    func showDetail(isbn13: String)
}
