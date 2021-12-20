//
//  NewRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import UIKit

protocol NewRouterType: AnyObject {
    var navigation: UINavigationController? { get }
    func showDetail(isbn13: String)
}

final class NewRouter: NewRouterType {
    weak var navigation: UINavigationController?
    
    func createModule() -> NewViewController {
        let interactor = NewInteractor()
        let presenter = NewPresenter()
        let view = NewViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = self
        view.presenter = presenter
        
        return view
    }
    
    func showDetail(isbn13: String) {
        guard let navigation = navigation else { return }
        let router = DetailRouter()
        router.navigation = navigation
        navigation.pushViewController(router.createModule(isbn13: isbn13), animated: true)
    }
}
