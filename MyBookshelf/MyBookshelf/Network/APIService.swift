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
    }
}

