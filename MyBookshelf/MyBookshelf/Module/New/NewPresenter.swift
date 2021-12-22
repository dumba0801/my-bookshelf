//
//  NewPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import Foundation
import RxSwift
import RxCocoa

final class NewPresenter {
    var interactor: NewInteractorType?
    var router: NewRouterType?
    weak var view: NewViewControllerType?
    private var disposeBag = DisposeBag()
    
}

extension NewPresenter: NewPresenterType {
    func fetchNewBooks(subject: Observable<Void>) {
        subject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard
                    let self = self,
                    let interactor = self.interactor
                else { return }
                interactor.fetchNewBooks()
            }).disposed(by: self.disposeBag)
    }
    
    func onFetchedNewBooks(subject: Observable<[Book]>) {
        guard let view = self.view else { return }
        view.onFetchedNewBooks(subject: subject)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        guard let view = self.view else { return }
        view.onFetchedError(subject: subject)
    }
    
    func showDetail(isbn13: String) {
        guard let router = self.router else { return }
        router.showDetail(isbn13: isbn13)
    }
}
