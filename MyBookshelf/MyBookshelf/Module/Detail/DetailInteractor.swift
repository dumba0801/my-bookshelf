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
import RealmSwift

final class DetailInteractor {
    weak var presenter: DetailPresenterType?
    let isbn13: String
    let service = APIService.shared
    private var disposeBag = DisposeBag()
    
    init(isbn13: String) {
        self.isbn13 = isbn13
    }
}

extension DetailInteractor: DetailInteractorType {
    func fetchBook() -> Observable<Book> {
        self.requestDetailBook()
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .asObservable()
    }
    
    private func requestDetailBook() -> Single<Book> {
        let endpoint = EndPoint(path: .detail(isbn13))
        let url = endpoint.url()
        return self.service.request(convertible: url)
            .map { data in
                let json = JSON(data)
                guard let book = Mapper<Book>().map(JSONObject: json.rawValue) else {
                    throw RxError.noElements
                }
                return book
            }
    }
    
    func fetchMemos() -> Observable<[Memo]> {
        do {
            let realm = try Realm()
            let memos = realm.objects(Memo.self).filter("isbn13 == '\(isbn13)'")
            
            return Observable.array(from: memos)
            
        } catch let error {
            return Observable.error(error)
        }
    }
}
