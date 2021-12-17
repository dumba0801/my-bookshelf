//
//  SearchPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import RxSwift

protocol SearchPresenterType: AnyObject {
    func fetchSearchBook(subject: Observable<String>) 
    func onFetchedSearchBook(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
}

final class SearchPresenter: SearchPresenterType {
    var interactor: SearchInteractorType?
    var router: SearchRouterType?
    weak var view: SearchViewType?
    
    private var disposeBag = DisposeBag()
    
    func fetchSearchBook(subject: Observable<String>) {
        subject.subscribe(onNext: { [weak self] keyword in
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
}
