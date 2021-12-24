//
//  SearchPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import RxSwift

final class SearchPresenter {
    var interactor: SearchInteractorType?
    var router: SearchRouterType?
    weak var view: SearchViewType?
    
    private var disposeBag = DisposeBag()
}

extension SearchPresenter: SearchPresenterType {
    func didTapedSearchButton(with keyword: String?) {
        guard let keyword = keyword else { return }
        
        self.requestBooksToInteractor(with: keyword)
    }
    
    func didTapedBookCell(isbn13: String) {
        self.router?.showDetail(isbn13: isbn13)
    }
    
    func didTapedRetryButton(with keyword: String?) {
        guard let keyword = keyword else { return }
        
        self.requestBooksToInteractor(with: keyword)
    }
    
    private func requestBooksToInteractor(with keyword: String) {
        self.interactor?
            .fetchSearchBooks(with: keyword)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.view?.drawView(with: books)
            }, onError: { [weak self] error in
                self?.view?.drawErrorView(with: error)
            }).disposed(by: self.disposeBag)

    }
    
    
}
