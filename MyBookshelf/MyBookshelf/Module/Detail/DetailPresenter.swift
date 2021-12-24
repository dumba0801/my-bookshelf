//
//  DetailPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import Foundation
import RxSwift

final class DetailPresenter {
    var interactor: DetailInteractorType?
    var router: DetailRouterType?
    weak var view: DetailViewControllerType?
    
    private var disposeBag = DisposeBag()
}

extension DetailPresenter: DetailPresenterType {
    func prepareViewDidLoad() {
        guard let interactor = interactor else { return }
        
        let book = interactor.fetchBook()
        let memos = interactor.fetchMemos()
        
        Observable.combineLatest(book, memos)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] book, memos in
                self?.view?.drawView(with: (book, memos))
            } onError: { error in
                self.view?.drawErrorView(with: error)
            }.disposed(by: disposeBag)
    }
    
    func didTapedAddMemoButton() {
        guard let interactor = interactor else { return }
        self.router?.showMemoModal(isbn13: interactor.isbn13)
    }
}
