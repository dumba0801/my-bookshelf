//
//  NewInteractorTask.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/15.
//

import Foundation
import RxSwift
import SwiftyJSON
import ObjectMapper

final class NewInteractorUseCase {
    let service = APIService.shared
    
    func requestNewBooks() -> Single<[Book]> {
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
extension String {
    func image() -> Single<UIImage?> {
        return APIService.shared.request(convertible: self)
            .map{ UIImage(data: $0) }
    }
}
