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
    func fetchSearchBooks(keyword: String)
}

final class SearchInteractor: SearchInteractorType {
    
    weak var presenter: SearchPresenterType?
    private let service = APIService.shared
    private var disposeBag = DisposeBag()
    
    func fetchSearchBooks(keyword: String) {
        guard let presenter = presenter else { return }
        let subject = BehaviorRelay<[(String, [Book])]>(value: [])
        
        pagination(subject: subject, keyword: keyword)
        
        let mapSubject = subject.map { $0.sorted{ $0.0 < $1.0 }.reduce([]) { $0 + $1.1 } }
        
        presenter.onFetchedSearchBook(subject: mapSubject)
    }
    
    private func pagination(subject: BehaviorRelay<[(String, [Book])]>,
                    keyword: String,
                    page: String = "1"
    ){
        requestSearchBooks(keyword: keyword, page: page)
            .subscribe { [weak self] (page, books) in
                guard let self = self,
                      !books.isEmpty else { return }
                let intPage = Int(page) ?? 0   // .... ?
                let nextPage = String(intPage + 1)
                var value = subject.value
                self.pagination(subject: subject, keyword: keyword, page: nextPage)
                value.append((page, books))
                subject.accept(value)
            }.disposed(by: disposeBag)
        
    }
    
    private func requestSearchBooks(keyword: String, page: String) -> Single<(String, [Book])> {
        let endpoint = EndPoint(path: .search(keyword, page))
        let url = endpoint.url()
        return service.request(convertible: url!)
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

enum DumbaError: Error {
    case decodingError
}

