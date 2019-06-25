//
//  FavoriteRepository.swift
//  MovieDB
//
//  Created by cuonghx on 6/24/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

protocol FavoriteRepositoryType {
    func add(_ item: Movie) -> Observable<Void>
    func getAll() -> Observable<[Movie]>
    func delete(_ item: Movie) -> Observable<Void>
    func toggle(_ item: Movie) -> Observable<Void>
    func tracking(_ item: Movie) -> Observable<Bool>
}

struct FavoriteRepository: FavoriteRepositoryType {
    
    func add(_ item: Movie) -> Observable<Void> {
        return add(item: item)
    }
    
    func getAll() -> Observable<[Movie]> {
        return all()
            .map {
                $0.sorted(byKeyPath: "addDate", ascending: false)
                    .toArray()
                    .compactMap {
                        FavoriteRepository.item(from: $0)
                    }
            }
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

extension FavoriteRepository: RealmRepository {
    
    static func map(from item: Movie, to: MovieRealm) {
        to.id = item.id
        to.genres = item.genres
            .map { String(describing: $0) }
            .joined(separator: ",")
        to.overview = item.overview
        to.posterPath = item.posterPath
        to.releaseDate = item.title
        to.voteAverage = item.voteAverage
        to.title = item.title
    }
    
    static func item(from: MovieRealm) -> Movie? {
        guard let title = from.title,
            let overview = from.overview,
            let genres = from.genres,
            let releaseDate = from.releaseDate,
            let posterPath = from.posterPath else {
                return nil
        }
        return Movie(id: from.id,
                     title: title,
                     overview: overview,
                     genres: genres
                        .components(separatedBy: ",")
                        .compactMap { Int($0) },
                     releaseDate: releaseDate,
                     voteAverage: from.voteAverage,
                     posterPath: posterPath,
                     backdropPath: "")
    }
}
