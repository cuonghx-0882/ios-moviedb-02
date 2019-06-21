//
//  SearchResultModel.swift
//  MovieDB
//
//  Created by cuonghx on 6/20/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import RxDataSources

struct SearchResultModel {
    var movie: Movie
}

extension SearchResultModel: MovieModelType {
    var id: Int {
        return movie.id
    }
    
    var title: String {
        return movie.title
    }
    
    var genres: String {
        return movie.genres.convertListGenres()
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

extension SearchResultModel: IdentifiableType, Equatable {
    
    var identity: Int {
        return movie.id
    }
    
    static func == (lhs: SearchResultModel, rhs: SearchResultModel) -> Bool {
        return lhs.movie.id == rhs.movie.id
    }
}
