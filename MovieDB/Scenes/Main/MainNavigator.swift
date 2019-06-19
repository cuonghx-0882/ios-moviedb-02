//
//  MainNavigator.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

protocol MainNavigatorType {
    func getPopularScreen() -> PopularListViewController
}

struct MainNavigator: MainNavigatorType {
    var assembler: Assembler
    var navigation: UINavigationController
    
    func getPopularScreen() -> PopularListViewController {
        return assembler.resolve(navigationController: navigation).then({
            $0.tabBarItem = UITabBarItem(title: "Popular",
                                         image: UIImage(named: "popular")?
                                                .resizeImage(CGSize(width: 32,
                                                                    height: 32)),
                                         tag: 0)
        })
    }
}
