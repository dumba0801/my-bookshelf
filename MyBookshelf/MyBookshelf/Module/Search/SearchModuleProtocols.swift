//
//  SearchModuleProtocols.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/22.
//

import UIKit
import RxSwift

protocol SearchViewType: AnyObject {
    var presenter: SearchPresenterType? { get }
    
    func onFetchedSearchBooks(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
}

protocol SearchInteractorType: AnyObject {
    var presenter: SearchPresenterType? { get }
    var service: APIService { get }
    
    func fetchSearchBooks(keyword: String)
}

protocol SearchPresenterType: AnyObject {
    var view: SearchViewType? { get }
    var interactor: SearchInteractorType? { get }
    var router: SearchRouterType? { get }
    
    func fetchSearchBook(subject: Observable<String?>)
    func onFetchedSearchBook(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
    func showDetail(isbn13: String)
}

protocol SearchRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func createModule() -> SearchViewController
    func showDetail(isbn13: String)
}
