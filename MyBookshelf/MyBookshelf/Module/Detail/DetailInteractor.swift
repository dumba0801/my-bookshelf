//
//  DetailInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import Foundation
import RxSwift
import ObjectMapper
import SwiftyJSON

protocol DetailInteractorType: AnyObject {
    var presenter: DetailPresenterType? { get }
    var service: APIService { get }
    func fetchDetailBook()
}

final class DetailInteractor {
    weak var presenter: DetailPresenterType?
    private let isbn13: String
    let service = APIService.shared
    private var disposeBag = DisposeBag()
    
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
}

extension DetailInteractor: DetailInteractorType {
    func fetchDetailBook() {
        guard let presenter = presenter else { return }
        
        requestDetailBook()
            .subscribe { book in
                let subject = Observable<DetailBook>.just(book)
                presenter.onFetchedDetailBook(subject: subject)
            } onFailure: { error in
                let subject = Observable<Error>.just(error)
                presenter.onFetchedError(subject: subject)
            }.disposed(by: disposeBag)
    }
    
    private func requestDetailBook() -> Single<DetailBook> {
        let endpoint = EndPoint(path: .detail(isbn13))
        let url = endpoint.url()
        return service.request(convertible: url)
            .map { data in
                let json = JSON(data)
                guard let book = Mapper<DetailBook>().map(JSONObject: json.rawValue) else {
                    throw RxError.noElements
                }
                return book
            }
    }
}
