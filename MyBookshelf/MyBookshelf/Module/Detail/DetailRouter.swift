//
//  DetailRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit

protocol DetailRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    
    func createModule(isbn13: String) -> UIViewController
}

final class DetailRouter: DetailRouterType {
    weak var navigation: UINavigationController?
    
    func createModule(isbn13: String) -> UIViewController {
        let interactor = DetailInteractor(isbn13: isbn13)
        let presenter = DetailPresenter()
        let view = DetailViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.router = self
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
}

