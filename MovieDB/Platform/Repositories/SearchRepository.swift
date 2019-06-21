//
//  SearchRepository.swift
//  Project2
//
//  Created by cuonghx on 6/17/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

protocol SearchRepositoryType {
    func searchMoviesBy(keyword: String, page: Int) -> Observable<PagingInfo<SearchResultModel>>
    func searchMoviesBy(genre: Int, page: Int) -> Observable<PagingInfo<SearchResultModel>>
}

struct SearchRepository: SearchRepositoryType {
    
    func searchMoviesBy(keyword: String, page: Int) -> Observable<PagingInfo<SearchResultModel>> {
        let input = API.GetMovieByKeywordInput(query: keyword, page: page)
        return API.shared
            .getMovieByKeyword(input: input)
            .map { output in
                guard let movies = output.movies else {
                    throw APIInvalidResponseError()
                }
                return PagingInfo<SearchResultModel>(page: page,
                                                     items: movies.map {
                                                        SearchResultModel(movie: $0)
                                                     })
            }
    }
    
    func searchMoviesBy(genre: Int, page: Int) -> Observable<PagingInfo<SearchResultModel>> {
        let input = API.GetMovieByGenresInput(genre: genre, page: page)
        return API.shared
            .getMovieByGenres(input: input)
            .map { output in
                guard let movies = output.movies else {
                    throw APIInvalidResponseError()
                }
                return PagingInfo<SearchResultModel>(page: page,
                                                     items: movies.map {
                                                        SearchResultModel(movie: $0)
                                                     })
            }
    }
}
