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
        guard let presenter = presenter else { return }
        
        requestNewBooks()
            .subscribe { book in
                let subject = Observable<[Book]>.just(book)
                presenter.onFetchedNewBooks(subject: subject)
            } onFailure: { error in
                let subject = Observable<Error>.just(error)
                presenter.onFetchedError(subject: subject)
            }.disposed(by: disposeBag)
    }
    
    private func requestNewBooks() -> Single<[Book]> {
        let endpoint = EndPoint(path: .new)
        let url = endpoint.url()
        return service.request(convertible: url!) //need refactor
            .map { data in
                let json = JSON(data)
                let object = json["books"].arrayObject
                let books = Mapper<Book>().mapArray(JSONObject: object)
                return books ?? [] // need refactor
            }
    }
}
