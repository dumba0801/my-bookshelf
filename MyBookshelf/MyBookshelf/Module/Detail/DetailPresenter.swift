//
//  DetailPresenter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import Foundation
import RxSwift

protocol DetailPresenterType: AnyObject {
    func fetchDetailBook(subject: Observable<Void>)
    func onFetchedDetailBook(subject: Observable<DetailBook>)
    func onFetchedError(subject: Observable<Error>)
    func showMemoModal()
}

final class DetailPresenter {
    var interactor: DetailInteractorType?
    var router: DetailRouterType?
    weak var view: DetailViewControllerType?
    
    private var disposeBag = DisposeBag()
}

extension DetailPresenter: DetailPresenterType {
    func fetchDetailBook(subject: Observable<Void>) {
        subject.subscribe(onNext: {
            [weak self] _ in
                guard
                    let self = self,
                    let interactor = self.interactor
                else { return }
                interactor.fetchDetailBook()
        }).disposed(by: disposeBag)
    }
    
    func onFetchedDetailBook(subject: Observable<DetailBook>) {
        subject.subscribe(onNext: { [weak self] book in
            guard let self = self,
                  let view = self.view
            else { return }
            
            view.onFetchdedDeatilBook(subject: subject)
            
        }).disposed(by: disposeBag)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        guard let view = view else { return }
        
        view.onFetchedError(subject: subject)
    }
    
    func showMemoModal() {
        guard let router = router else { return }
        
        router.showMemoModal()
    }
}
