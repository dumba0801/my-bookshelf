//
//  DetailBook.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/20.
//

import Foundation
import ObjectMapper

struct DetailBook {
    var title: String!
    var subtitle: String!
    var authors: String!
    var publisher: String!
    var language: String!
    var pages: String!
    var year: String!
    var rating: String!
    var desc: String!
    var price: String!
    var imageUrl: String!
}

extension DetailBook: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        subtitle <- map["subtitle"]
        authors <- map["authors"]
        publisher <- map["publisher"]
        language <- map["language"]
        pages <- map["pages"]
        year <- map["year"]
        rating <- map["rating"]
        desc <- map["desc"]
        price <- map["price"]
        imageUrl <- map["image"]
    }
}
