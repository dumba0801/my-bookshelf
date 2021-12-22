//
//  SearchInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import RxSwift
import RxRelay
import SwiftyJSON
import ObjectMapper
protocol SearchInteractorType: AnyObject {
    var presenter: SearchPresenterType? { get }
    var service: APIService { get }
    func fetchSearchBooks(keyword: String)
}

final class SearchInteractor: SearchInteractorType {
    
    weak var presenter: SearchPresenterType?
    let service = APIService.shared
    private var disposeBag = DisposeBag()
    
    func fetchSearchBooks(keyword: String) {
        guard let presenter = presenter else { return }
        let subject = BehaviorSubject<[(String, [Book])]>(value: [])
        
        self.pagination(subject: subject, keyword: keyword)
        
        let mapSubject = subject.map{ $0.sorted{ $0.0 < $1.0 }.reduce([]) { $0 + $1.1 } }
        
        mapSubject
            .subscribe { books in
                let subject = Observable<[Book]>.just(books)
                presenter.onFetchedSearchBook(subject: subject)
            } onError: { error in
                let subject = Observable<Error>.just(error)
                presenter.onFetchedError(subject: subject)
            }.disposed(by: self.disposeBag)
    }
    
    private func pagination(subject: BehaviorSubject<[(String, [Book])]>,
                            keyword: String,
                            page: String = "1"
    ) {
        self.requestSearchBooks(keyword: keyword, page: page)
            .subscribe { [weak self] (page, books) in
                guard let self = self,
                      let page = Int(page),
                      !books.isEmpty
                else { return }
                
                let nextPage = String(page + 1)
                
                do {
                    var value = try subject.value()
                    self.pagination(subject: subject, keyword: keyword, page: nextPage)
                    value.append((nextPage, books))
                    subject.onNext(value)
                } catch let error {
                    subject.onError(error)
                }
            }  onFailure: { error in
                subject.onError(error)
            }.disposed(by: self.disposeBag)
    }
    
    private func requestSearchBooks(keyword: String, page: String) -> Single<(String, [Book])> {
        let endpoint = EndPoint(path: .search(keyword, page))
        let url = endpoint.url()
        return service.request(convertible: url)
            .map { data in
                let json = JSON(data)
                let object = json["books"].arrayObject
                guard let page = json["page"].string,
                      let books = Mapper<Book>().mapArray(JSONObject: object) else {
                          throw RxError.noElements
                      }
                
                return (page, books)
            }
    }
}
