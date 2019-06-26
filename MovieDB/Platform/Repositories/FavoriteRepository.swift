//
//  FavoriteRepository.swift
//  MovieDB
//
//  Created by cuonghx on 6/24/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import RealmSwift

protocol FavoriteRepositoryType {
    func add(_ item: Movie) -> Observable<Movie>
    func getAll() -> Observable<[Movie]>
    func delete(_ item: Movie) -> Observable<Void>
    func checkItemExist(_ item: Movie) -> Bool
}

struct FavoriteRepository: FavoriteRepositoryType {
    
    func add(_ item: Movie) -> Observable<Movie> {
        return RealmManager.sharedInstance.addData(item: item.clone())
    }
    
    func getAll() -> Observable<[Movie]> {
        return RealmManager.sharedInstance.getAllData()
    }
    
    func delete(_ item: Movie) -> Observable<Void> {
        return RealmManager.sharedInstance.deleteData(item: item.clone())
    }
    
    func checkItemExist(_ item: Movie) -> Bool {
        return RealmManager.sharedInstance.checkItemExist(item: item)
    }
}

