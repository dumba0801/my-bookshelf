//
//  EndPoint.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import Foundation

struct EndPoint {
    let scheme: String = "https"
    let host: String = "api.itbook.store"
    let base: String = "/1.0/"
    let path: Path

    enum Path {
        case new
        case search(String, String)
        case detail(String)
        
        var path: String {
            switch self {
            case .new:
                return "new"
            case .search(let keyword, let page):
                return "search/" + keyword + "/" + page
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
