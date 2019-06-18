//
//  APIUrls.swift
//  MovieDB
//
//  Created by cuonghx on 6/2/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

extension API {
    enum Urls {
        private static var apiBaseURL = "https://api.themoviedb.org/3"
        static let keywordURL = apiBaseURL + "/search/keyword"
        static let moviesURL = apiBaseURL + "/movie"
        static let discoverURL = apiBaseURL + "/discover"
        static let genresURL = apiBaseURL + "/genre/movie/list"
        
        static let posterUrl = "https://image.tmdb.org/t/p/w185"
        static let backdropUrl = "https://image.tmdb.org/t/p/w500"
        static let profileUrl = "https://image.tmdb.org/t/p/w154"
        
    }
}
