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
    func prepareViewDidLoad() {
        interactor?.fetchNewBooks()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.view?.drawView(with: books)
            }, onError: { [weak self] error in
                self?.view?.drawErrorView(with: error)
            }).disposed(by: self.disposeBag)
    }
    
    func didTapedRetryButton() {
        interactor?.fetchNewBooks()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] books in
                self?.view?.drawView(with: books)
            }, onError: { [weak self] error in
                self?.view?.drawErrorView(with: error)
            }).disposed(by: self.disposeBag)
    }

    func didTapedBookCell(isbn13: String) {
        router?.showDetail(isbn13: isbn13)
    }
}
