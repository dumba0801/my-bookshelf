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
    
    func drawView(with data: (Book, [Memo]))
    func drawErrorView(with error: Error)
}

protocol DetailInteractorType: AnyObject {
    var presenter: DetailPresenterType? { get }
    var isbn13: String { get }
    var service: APIService { get }
    
    func fetchBook() -> Observable<Book>
    func fetchMemos() -> Observable<[Memo]>
}

protocol DetailPresenterType: AnyObject {
    var view: DetailViewControllerType? { get }
    var interactor: DetailInteractorType? { get }
    var router: DetailRouterType? { get }
    
    func prepareViewDidLoad()
    func didTapedAddMemoButton()
}

protocol DetailRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func createModule(isbn13: String) -> UIViewController
    func showMemoModal(isbn13: String)
}
