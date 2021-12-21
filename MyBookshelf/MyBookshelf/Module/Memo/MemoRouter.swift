//
//  MemoRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import UIKit

protocol MemoRouterType: AnyObject {
}

final class MemoRouter {
    weak var navigation: UINavigationController?
    
    func createModule() -> MemoViewController {
        let interactor = MemoInteractor()
        let presenter = MemoPresenter()
        let view = MemoViewController()
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        presenter.view = view
        presenter.router = self
        view.presenter = presenter
    
        return view
    }
    
}

extension MemoRouter: MemoRouterType {
    
}
