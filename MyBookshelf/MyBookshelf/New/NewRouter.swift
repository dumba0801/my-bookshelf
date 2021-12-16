//
//  NewRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/14.
//

import Foundation

protocol NewRouterType: AnyObject {
}

final class NewRouter: NewRouterType {
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
}
