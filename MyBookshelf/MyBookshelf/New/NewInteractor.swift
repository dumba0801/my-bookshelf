//
//  NewInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewInteractorType: AnyObject {
    var presenter: NewPresenterType? { get }
    var useCase: NewInteractorUseCase { get }
    func fetchNewBooks() 
}

final class NewInteractor {
    weak var presenter: NewPresenterType?
    var useCase = NewInteractorUseCase()
    private var disposeBag = DisposeBag()

}

extension NewInteractor: NewInteractorType {
    func fetchNewBooks() {
        guard let presenter = presenter else { return }
    
        useCase.requestNewBooks()
            .subscribe { book in
            let subject = Observable<[Book]>.just(book)
            presenter.onFetchedNewBooks(subject: subject)
        } onFailure: { error in
            let subject = Observable<Error>.just(error)
            presenter.onFetchedError(subject: subject)
        }.disposed(by: disposeBag)
    }
}
