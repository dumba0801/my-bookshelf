//
//  SearchRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import UIKit

protocol SearchRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func createModule() -> SearchViewController
    func showDetail(isbn13: String)
}

final class SearchRouter: SearchRouterType {
    var navigation: UINavigationController?
    
    func createModule() -> SearchViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = self
        interactor.presenter = presenter
        
        return view
    }
    
    func showDetail(isbn13: String) {
        guard let navigation = self.navigation else { return }
        let router = DetailRouter()
        router.navigation = navigation
        navigation.pushViewController(router.createModule(isbn13: isbn13), animated: true)
    }
    
}
