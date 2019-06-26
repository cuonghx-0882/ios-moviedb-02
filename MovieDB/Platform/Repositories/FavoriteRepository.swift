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
    func toggle(_ item: Movie) -> Observable<Void>
    func tracking(_ item: Movie) -> Observable<Bool>
}

struct FavoriteRepository: FavoriteRepositoryType, RealmRepository {
    
    func add(_ item: Movie) -> Observable<Movie> {
        return add(item: item)
    }
    
    func getAll() -> Observable<[Movie]> {
        return getAllItem()
    }
    
    func delete(_ item: Movie) -> Observable<Void> {
        return delete(item: item)
    }
    
    func toggle(_ item: Movie) -> Observable<Void> {
        return toggle(item: item)
    }
    
    func tracking(_ item: Movie) -> Observable<Bool> {
        return tracking(item: item)
    }
}

