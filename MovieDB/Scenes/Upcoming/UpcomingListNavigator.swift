//
//  UpcomingListNavigator.swift
//  MovieDB
//
//  Created by cuonghx on 6/20/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol UpcomingListNavigatorType {
    func toDetailVC(movieModel: MovieModelType)
}

struct UpcomingListNavigator: UpcomingListNavigatorType {
    var assembler: Assembler
    var navigation: UINavigationController
    
    func toDetailVC(movieModel: MovieModelType) {
        let detailVC: DetailViewController = assembler.resolve(navigation: navigation,
                                                               movieModel: movieModel)
        navigation.pushViewController(detailVC, animated: true)
    }
}
