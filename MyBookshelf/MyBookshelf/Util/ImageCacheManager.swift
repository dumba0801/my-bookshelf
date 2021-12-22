//
//  ImageCacheManager.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit
import RxRealm

final class ImageCacheManager {
    static private var cache = NSCache<NSString, UIImage>()
    
    static func image(key: NSString) -> UIImage? {
        self.cache.object(forKey: key)
    }
    
    static func save(key: NSString, image: UIImage) {
        self.cache.setObject(image, forKey: key)
    }
}
