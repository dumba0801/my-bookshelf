//
//  SearchPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import RxSwift

final class SearchPresenter: SearchPresenterType {
    var interactor: SearchInteractorType?
    var router: SearchRouterType?
    weak var view: SearchViewType?
    
    private var disposeBag = DisposeBag()
    
    func fetchSearchBook(subject: Observable<String?>) {
        subject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self,
                      let interactor = self.interactor
                else { return }
                
                interactor.fetchSearchBooks(keyword: keyword)
            }).disposed(by: self.disposeBag)
        
    }
    
    func onFetchedSearchBook(subject: Observable<[Book]>) {
        guard let view = view else { return }
        
        view.onFetchedSearchBooks(subject: subject)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        guard let view = view else { return }
        
        view.onFetchedError(subject: subject)
    }
    
    func showDetail(isbn13: String) {
        guard let router = router else { return }
        router.showDetail(isbn13: isbn13)
    }
}

