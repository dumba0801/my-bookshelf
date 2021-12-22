//
//  MemoRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/21.
//

import UIKit

protocol MemoRouterType: AnyObject {
    func dismiss()
}

final class MemoRouter {
    weak var navigation: UINavigationController?
    
    func createModule(isbn13: String) -> MemoViewController {
        let interactor = MemoInteractor(isbn13: isbn13)
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
    func dismiss() {
        guard let navigation = navigation else { return }
        navigation.dismiss(animated: true, completion: nil)
    }
    
}
