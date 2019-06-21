//
//  SearchUseCase.swift
//  MovieDB
//
//  Created by cuonghx on 6/21/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

protocol SearchUseCaseType {
    func getMovieBy(keyword: String) -> Observable<PagingInfo<SearchResultModel>>
    func loadMoreMovieByKeyword(keyword: String, page: Int) -> Observable<PagingInfo<SearchResultModel>>
    func getMovieBy(genre: Int) -> Observable<PagingInfo<SearchResultModel>>
    func loadMoreMovieBy(genre: Int, page: Int) -> Observable<PagingInfo<SearchResultModel>>
    func getListGenres() -> Observable<[GenreModel]>
    func getGenresID(index: Int) -> Int
}

struct SearchUseCase: SearchUseCaseType {
    
    var searchRepo: SearchRepositoryType
    
    func getMovieBy(keyword: String) -> Observable<PagingInfo<SearchResultModel>> {
        return loadMoreMovieByKeyword(keyword: keyword, page: 1)
    }
    
    func loadMoreMovieByKeyword(keyword: String, page: Int) -> Observable<PagingInfo<SearchResultModel>> {
        return  searchRepo.searchMoviesBy(keyword: keyword, page: page)
    }
    
    func getMovieBy(genre: Int) -> Observable<PagingInfo<SearchResultModel>> {
        return loadMoreMovieBy(genre: genre, page: 1)
    }
    
    func loadMoreMovieBy(genre: Int, page: Int) -> Observable<PagingInfo<SearchResultModel>> {
        return searchRepo.searchMoviesBy(genre: genre, page: page)
    }
    
    func getListGenres() -> Observable<[GenreModel]> {
        let genreList = Constants.genres
            .map {
                GenreModel(name: $0.value, id: $0.key)
            }
        return Observable.just(genreList)
    }
    
    func getGenresID(index: Int) -> Int {
        return Array(Constants.genres.keys)[index]
    }
}
