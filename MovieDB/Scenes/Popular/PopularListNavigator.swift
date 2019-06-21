//
//  PopularNavigator.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.

protocol PopularListNavigatorType {
    func toDetailVC(movieModel: MovieModelType)
}

struct PopularListNavigator: PopularListNavigatorType {
    var assembler: Assembler
    var navigation: UINavigationController
    
    func toDetailVC(movieModel: MovieModelType) {
        let detailVC: DetailViewController = assembler.resolve(navigation: navigation,
                                                               movieModel: movieModel)
        navigation.pushViewController(detailVC, animated: true)
    }
}
