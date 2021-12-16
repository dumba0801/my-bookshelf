//
//  Book.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import Foundation
import ObjectMapper

struct Book: Mappable {
    var title: String?
    var subtitle: String?
    var isbn13: String?
    var price: String?
    var image: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        subtitle <- map["subtitle"]
        isbn13 <- map["isbn13"]
        price <- map["price"]
        image <- map["image"]
    }
}
