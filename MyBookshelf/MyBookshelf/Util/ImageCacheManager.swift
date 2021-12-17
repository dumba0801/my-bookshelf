//
//  ImageCacheManager.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit

final class ImageCacheManager {
    static private var cache = NSCache<NSString, UIImage>()
    
    static func image(key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }
    
    static func save(key: NSString, image: UIImage) {
        self.cache.setObject(image, forKey: key)
    }
}
