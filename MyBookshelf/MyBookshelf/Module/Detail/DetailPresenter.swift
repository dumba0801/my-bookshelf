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
    func fetchMemos(subject: Observable<Void>)
    func onFetchedDetailBook(subject: Observable<DetailBook>)
    func onFetchedError(subject: Observable<Error>)
    func onFetchedMemos(subject: Observable<[Memo]>)
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
        subject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard
                    let self = self,
                    let interactor = self.interactor
                else { return }
                interactor.fetchDetailBook()
            }).disposed(by: self.disposeBag)
    }
    
    func fetchMemos(subject: Observable<Void>) {
        subject.subscribe(onNext: { [weak self] _ in
            guard
                let self = self,
                let interactor = self.interactor
            else {
                return
            }
            
            interactor.fetchMemos()
        }).disposed(by: self.disposeBag)
    }
    
    func onFetchedDetailBook(subject: Observable<DetailBook>) {
        subject.subscribe(onNext: { [weak self] book in
            guard let self = self,
                  let view = self.view
            else { return }
            
            view.onFetchdedDeatilBook(subject: subject)
            
        }).disposed(by: self.disposeBag)
    }
    
    func onFetchedError(subject: Observable<Error>) {
        guard let view = self.view else { return }
        
        view.onFetchedError(subject: subject)
    }
    
    func showMemoModal() {
        guard
            let router = self.router,
            let interactor = self.interactor
        else {
            return
        }
        
        router.showMemoModal(isbn13: interactor.isbn13)
    }
    
    func onFetchedMemos(subject: Observable<[Memo]>) {
        guard let view = self.view else { return }
        
        view.onFetchedMemos(subject: subject)
    }
}
