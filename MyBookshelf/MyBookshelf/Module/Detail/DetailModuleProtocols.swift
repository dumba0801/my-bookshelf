//
//  DetailModuleProtocols.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/22.
//

import UIKit
import RxSwift

protocol DetailViewControllerType: AnyObject {
    var presenter: DetailPresenterType? { get }
    
    func onFetchdedDeatilBook(subject: Observable<DetailBook>)
    func onFetchedMemos(subject: Observable<[Memo]>)
    func onFetchedError(subject: Observable<Error>)
}

protocol DetailInteractorType: AnyObject {
    var presenter: DetailPresenterType? { get }
    var isbn13: String { get }
    var service: APIService { get }
    
    func fetchDetailBook()
    func fetchMemos()
}

protocol DetailPresenterType: AnyObject {
    var view: DetailViewControllerType? { get }
    var interactor: DetailInteractorType? { get }
    var router: DetailRouterType? { get }
    
    func fetchDetailBook(subject: Observable<Void>)
    func fetchMemos(subject: Observable<Void>)
    func onFetchedDetailBook(subject: Observable<DetailBook>)
    func onFetchedError(subject: Observable<Error>)
    func onFetchedMemos(subject: Observable<[Memo]>)
    func showMemoModal()
}

protocol DetailRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func createModule(isbn13: String) -> UIViewController
    func showMemoModal(isbn13: String)
}
