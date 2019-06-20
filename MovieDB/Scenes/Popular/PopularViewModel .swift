//
//  PopularViewModel.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import RxDataSources

struct PopularViewModel {
    let movie: Movie
}

extension PopularViewModel: MovieModelType {
    var title: String {
        return movie.title
    }
    
    var genres: String {
        return convertListGenres(genres: movie.genres)
    }
    
    var overview: String {
        return movie.overview
    }
    
    var voteAverage: Double {
        return movie.voteAverage / 2
    }
    
    var posterPath: String {
        return movie.posterPath
    }
    
    var releaseDate: String {
        return movie.releaseDate
    }
}

extension PopularViewModel: IdentifiableType, Equatable {
    var identity: Int {
        return movie.id
    }
    
    static func == (lhs: PopularViewModel, rhs: PopularViewModel) -> Bool {
        return lhs.movie.id == rhs.movie.id
    }
}

extension PopularViewModel {
    private func convertListGenres(genres: [Int]) -> String {
        guard !genres.isEmpty else { return "" }
        return genres
            .compactMap {
                Constants.genres[$0]
            }
            .joined(separator: ", ")
    }
}
