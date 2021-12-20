//
//  NewPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewPresenterType: AnyObject {
    var interactor: NewInteractorType? { get }
    func fetchNewBooks(subject: Observable<Void>)
    func showDetail(isbn13: String)
    func onFetchedNewBooks(subject: Observable<[Book]>)
    func onFetchedError(subject: Observable<Error>)
}

final class NewPresenter {
    var interactor: NewInteractorType?
    var router: NewRouterType?
    weak var view: NewViewControllerType?
    private var disposeBag = DisposeBag()
    
}

extension NewPresenter: NewPresenterType {
    func fetchNewBooks(subject: Observable<Void>) {
        subject.subscribe(onNext: {
            [weak self] _ in
                guard
                    let self = self,
                    let interactor = self.interactor
                else { return }
                interactor.fetchNewBooks()
        }).disposed(by: disposeBag)
    }
    
    func onFetchedNewBooks(subject: Observable<[Book]>) {
        guard let view = view else { return }
        view.onFetchedNewBooks(subject: subject)
    }
        
    func onFetchedError(subject: Observable<Error>) {
        
    }
    
    func showDetail(isbn13: String) {
        guard let router = router else { return }
        router.showDetail(isbn13: isbn13)
    }
}
