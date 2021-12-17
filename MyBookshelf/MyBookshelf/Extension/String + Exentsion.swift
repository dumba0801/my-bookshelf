//
//  String + Exentsion.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit
import RxSwift

extension String {
    func image() -> Single<UIImage?> {
        if let image = ImageCacheManager.image(key: NSString(string: self)) {
            return Observable<UIImage?>.just(image).asSingle()
        }
        
        return APIService.shared.request(convertible: self)
            .map{ UIImage(data: $0) }
            .do(onSuccess: { image in
                guard let image = image else { return }
                ImageCacheManager.save(key: NSString(string: self), image: image)
            })
    }
}
