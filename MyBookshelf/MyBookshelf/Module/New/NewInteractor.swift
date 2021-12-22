//
//  NewInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import SwiftyJSON

protocol NewInteractorType: AnyObject {
    var presenter: NewPresenterType? { get }
    var service: APIService { get }
    func fetchNewBooks()
}

final class NewInteractor {
    weak var presenter: NewPresenterType?
    let service = APIService.shared
    private var disposeBag = DisposeBag()
    
}

extension NewInteractor: NewInteractorType {
    func fetchNewBooks() {
        guard let presenter = self.presenter else { return }
        
        self.requestNewBooks()
            .subscribe { book in
                let subject = Observable<[Book]>.just(book)
                presenter.onFetchedNewBooks(subject: subject)
            } onFailure: { error in
                let subject = Observable<Error>.just(error)
                presenter.onFetchedError(subject: subject)
            }.disposed(by: self.disposeBag)
        
    }
    
    private func requestNewBooks() -> Single<[Book]> {
        let endpoint = EndPoint(path: .new)
        let url = endpoint.url()
        return self.service.request(convertible: url)
            .map { data in
                let json = JSON(data)
                let object = json["books"].arrayObject
                guard let books = Mapper<Book>().mapArray(JSONObject: object) else {
                    throw RxError.noElements
                }
                return books
            }
    }
}
