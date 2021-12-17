//
//  NewRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import UIKit

protocol NewRouterType: AnyObject {
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
        view.presenter = presenter
        
        return view
    }
    
    func pushDetail() {
        guard let navigation = navigation else { return }
        let router = DetailRouter()
        router.navigation = navigation
        navigation.pushViewController(router.createModule(), animated: true)
    }
}
