//
//  SearchPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import RxSwift

protocol SearchPresenterType: AnyObject {
    var interactor: SearchInteractorType? { get }
    var router: SearchRouterType? { get }
    var view: SearchViewType? { get }
    
    func fetchSearchBook(subject: Observable<String?>) 
    func onFetchedSearchBook(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
    func showDetail(isbn13: String)
}

final class SearchPresenter: SearchPresenterType {
    var interactor: SearchInteractorType?
    var router: SearchRouterType?
    weak var view: SearchViewType?
    
    private var disposeBag = DisposeBag()
    
    func fetchSearchBook(subject: Observable<String?>) {
        subject
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] keyword in
            guard let self = self,
                  let interactor = self.interactor
            else { return }

            interactor.fetchSearchBooks(keyword: keyword)
        }).disposed(by: disposeBag)
        
    }
    
    func onFetchedSearchBook(subject: Observable<[Book]>) {
        guard let view = view else { return }
        
        view.onFetchedSearchBooks(subject: subject)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        
    }
    
    func showDetail(isbn13: String) {
        guard let router = router else { return }
        router.showDetail(isbn13: isbn13)
    }
}

