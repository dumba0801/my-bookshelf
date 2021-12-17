//
//  SearchRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/16.
//

import Foundation
import UIKit

protocol SearchRouterType: AnyObject {
    
}

final class SearchRouter: SearchRouterType {
    static var navigation: UINavigationController?
    
    func createModule() -> SearchViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
        
        return view
    }
    
}
