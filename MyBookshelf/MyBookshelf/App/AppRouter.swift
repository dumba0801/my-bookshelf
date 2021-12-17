//
//  AppRouter.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/17.
//

import UIKit

final class AppRouter {
    static func create() -> UIViewController {
        let newVC = NewRouter().createModule()
        let newNavigation = UINavigationController(rootViewController: newVC)
        newNavigation.navigationBar.prefersLargeTitles = true
        
        let searchVC = SearchRouter().createModule()
        let searchNavigation = UINavigationController(rootViewController: searchVC)
        searchNavigation.navigationBar.prefersLargeTitles = true
        
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [newNavigation, searchNavigation]

        return tabBarVC
    }
}
