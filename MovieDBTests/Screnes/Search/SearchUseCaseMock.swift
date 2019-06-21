//
//  SearchUseCaseMock.swift
//  MovieDBTests
//
//  Created by cuonghx on 6/21/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import XCTest

@testable import MovieDB

final class SearchUseCaseMock: SearchUseCaseType {
    
    var movieListReturn: Observable<PagingInfo<SearchResultModel>> = {
        let searchResult = SearchResultModel(movie: Movie().with { $0.id = 1 })
        let page = PagingInfo<SearchResultModel> (page: 1,
                                                  items: [searchResult])
        return Observable.just(page)
    }()
    var getMovieListByKeywordCalled: XCTestExpectation?
    var getMovieByGenreCalled: XCTestExpectation!
    
    func getMovieBy(keyword: String) -> Observable<PagingInfo<SearchResultModel>> {
        getMovieListByKeywordCalled?.fulfill()
        return loadMoreMovieByKeyword(keyword: keyword, page: 1)
    }
    
    func loadMoreMovieByKeyword(keyword: String, page: Int) -> Observable<PagingInfo<SearchResultModel>> {
        return movieListReturn
    }
    
    func getMovieBy(genre: Int) -> Observable<PagingInfo<SearchResultModel>> {
        getMovieByGenreCalled?.fulfill()
        return loadMoreMovieBy(genre: genre, page: 1)
    }
    
    func loadMoreMovieBy(genre: Int, page: Int) -> Observable<PagingInfo<SearchResultModel>> {
        return movieListReturn
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

