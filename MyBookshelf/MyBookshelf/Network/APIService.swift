//
//  APIService.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/15.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func request(convertible: URLConvertible) -> Single<Data> {
        return Observable<Data>.create() { subject in
            AF.request(convertible)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        subject.onNext(data)
                        subject.onCompleted()
                    case .failure(let error):
                        subject.onError(error)
                    }
            }
            return Disposables.create()
        }.asSingle()
    }}

struct EndPoint {
    let scheme: String = "https"
    let host: String = "api.itbook.store"
    let base: String = "/1.0/"
    let path: Path

    enum Path {
        case new
        case search(String)
        case detail(String)
        
        var path: String {
            switch self {
            case .new:
                return "new"
            case .search(let keyword):
                return "search/" + keyword
            case .detail(let id):
                return "books/" + id
            }
        }
    }
    
    func url() -> URL? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = base + path.path
        return components.url
    }
}

