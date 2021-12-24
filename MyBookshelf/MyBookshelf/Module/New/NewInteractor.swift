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


struct BookInfo {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let imageUrl: String
    
    init(
        title: String,
        subtitle: String,
        isbn13: String,
        price: String,
        imageUrl: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.isbn13 = isbn13
        self.price = price
        self.imageUrl = imageUrl
    }
    
    init(book: Book) {
        self.title = book.title
        self.subtitle = book.subtitle
        self.isbn13 = book.isbn13
        self.price = book.price
        self.imageUrl = book.imageUrl
    }
}


final class NewInteractor {
    weak var presenter: NewPresenterType?
    let service = APIService.shared
    private var disposeBag = DisposeBag()
    
}

extension NewInteractor: NewInteractorType {
    func fetchNewBooks() -> Observable<[BookInfo]> {
        return self.requestNewBooks()
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .map { $0.map{ BookInfo(book: $0)} }
            .asObservable()
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
