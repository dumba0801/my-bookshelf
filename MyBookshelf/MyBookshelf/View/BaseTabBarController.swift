//
//  BaseTabBarController.swift
//  MyBookshelf
//
//  Created by dumba on 2021/12/20.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    init(new: UINavigationController, search: UINavigationController) {
        super.init(nibName: nil, bundle: nil)
        
        new.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks,
                                      tag: Constant.newViewControllerTag)
        search.tabBarItem = UITabBarItem(tabBarSystemItem: .search,
                                         tag: Constant.searchViewControllerTag)
        
        viewControllers = [new, search]
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        tabBar.scrollEdgeAppearance = appearance
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BaseTabBarController {
    enum Constant {
        static let newViewControllerTag = 1
        static let searchViewControllerTag = 2
    }
}
