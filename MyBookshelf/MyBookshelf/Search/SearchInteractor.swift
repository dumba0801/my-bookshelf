//
//  SearchInteractor.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import RxSwift
import SwiftyJSON
import ObjectMapper

protocol SearchInteractorType: AnyObject {
    func fetchSearchBooks(keyword: String) 
}

final class SearchInteractor: SearchInteractorType {
    
    weak var presenter: SearchPresenterType?
    private var useCase = SearchInteractorUseCase()
    private var disposeBag = DisposeBag()
    
    func fetchSearchBooks(keyword: String) {
        guard let presenter = presenter else { return }
        
        useCase.requestSearchBooks(keyword: keyword)
            .subscribe { books in
                let subject = Observable<[Book]>.just(books)
                presenter.onFetchedSearchBook(subject: subject)
            } onFailure: { error in
                let subject = Observable<Error>.just(error)
                presenter.onFetchedError(subject: subject)
            }.disposed(by: disposeBag)
    }
    
}

final class SearchInteractorUseCase {
    let service = APIService.shared
    
    func requestSearchBooks(keyword: String) -> Single<[Book]> {
        let endpoint = EndPoint(path: .search(keyword))
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
