//
//  UITabBarController+Rx.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

extension Reactive where Base: UITabBarController {
    var viewcontrollers: Binder<[UIViewController]> {
        return Binder<[UIViewController]>(base) { tabvc, vcs in
            tabvc.viewControllers = vcs
        }
    }
}
