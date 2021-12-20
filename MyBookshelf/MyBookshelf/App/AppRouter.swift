//
//  AppRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit

final class AppRouter {
    static func create() -> UIViewController {
        let newRouter = NewRouter()
        let newVC = newRouter.createModule()
        let newNavigation = UINavigationController(rootViewController: newVC)
        newNavigation.navigationBar.prefersLargeTitles = true
        newRouter.navigation = newNavigation
        
        let searchRouter = SearchRouter()
        let searchVC = searchRouter.createModule()
        let searchNavigation = UINavigationController(rootViewController: searchVC)
        searchNavigation.navigationBar.prefersLargeTitles = true
        searchRouter.navigation = searchNavigation
        
        let tabBarVC = BaseTabBarController(new: newNavigation, search: searchNavigation)
        return tabBarVC
    }
}
