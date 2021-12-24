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
    
    func drawView(with books: [BookInfo])
    func drawErrorView(with error: Error)
}

protocol SearchInteractorType: AnyObject {
    var presenter: SearchPresenterType? { get }
    var service: APIService { get }
    
    func fetchSearchBooks(with keyword: String) -> Observable<[BookInfo]>
}

protocol SearchPresenterType: AnyObject {
    var view: SearchViewType? { get }
    var interactor: SearchInteractorType? { get }
    var router: SearchRouterType? { get }
    
    func didTapedSearchButton(with keyword: String?)
    func didTapedRetryButton(with keyword: String?)
    func didTapedBookCell(isbn13: String)
}

protocol SearchRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func createModule() -> SearchViewController
    func showDetail(isbn13: String)
}
