//
//  SearchViewModelTests.swift
//  MovieDBTests
//
//  Created by cuonghx on 6/21/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import XCTest

@testable import MovieDB

// swiftlint:disable force_try
final class SearchViewModelTests: XCTestCase {
    
    private var usecase: SearchUseCaseMock!
    private var navigator: SearchNavigatorMock!
    private var viewModel: SearchViewModel!
    
    private var input: SearchViewModel.Input!
    private var output: SearchViewModel.Output!
    
    private let disposeBag = DisposeBag()
    
    private let loadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let refreshTrigger = PublishSubject<Void>()
    private let selectionGenre = PublishSubject<IndexPath>()
    private let selectionMovie = PublishSubject<IndexPath>()
    private let textSearch = PublishSubject<String>()
    
    override func setUp() {
        super.setUp()
        usecase = SearchUseCaseMock()
        navigator = SearchNavigatorMock()
        viewModel = SearchViewModel(usecase: usecase,
                                    navigator: navigator)
        input = SearchViewModel.Input(loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
                                      loadMoreTrigger: loadMoreTrigger.asDriverOnErrorJustComplete(),
                                      refreshTrigger: refreshTrigger.asDriverOnErrorJustComplete(),
                                      selectionGenre: selectionGenre.asDriverOnErrorJustComplete(),
                                      textSearch: textSearch.asDriverOnErrorJustComplete(),
                                      selectionMovie: selectionMovie.asDriverOnErrorJustComplete())
        output = viewModel.transform(input)
        output.clearSelectedGenre
            .drive()
            .disposed(by: disposeBag)
        output.clearTextInSearchBar
            .drive()
            .disposed(by: disposeBag)
        output.error
            .drive()
            .disposed(by: disposeBag)
        output.fetchItems
            .drive()
            .disposed(by: disposeBag)
        output.genresList
            .drive()
            .disposed(by: disposeBag)
        output.gotoTop
            .drive()
            .disposed(by: disposeBag)
        output.loading
            .drive()
            .disposed(by: disposeBag)
        output.loadingMore
            .drive()
            .disposed(by: disposeBag)
        output.movieResult
            .drive()
            .disposed(by: disposeBag)
        output.refreshing
            .drive()
            .disposed(by: disposeBag)
        output.selectedMovie
            .drive()
            .disposed(by: disposeBag)
    }
    
    func test_loadTrigger_getMoviesList() {
        
        let expect = self.expectation(description: "expect getMovieByGenres() to be called")
        usecase.getMovieByGenreCalled = expect
        // act
        textSearch.onNext("")
        selectionGenre.onNext(IndexPath(row: 0, section: 0))
        loadTrigger.onNext(())
        
        // expect
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_textChange_getMoviesList_byKeyword() {
        let expect = self.expectation(description: "expect getMoviesByKeyword() to be called")
        usecase.getMovieListByKeywordCalled = expect
        // act
        textSearch.onNext("")
        selectionGenre.onNext(IndexPath(row: 0, section: 0))
        textSearch.onNext("abcd")
        
        // expect
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_selectGenres_getMoviesList_byGenre() {
        let expect = self.expectation(description: "expect getMoviesByGenres() to be called")
        usecase.getMovieByGenreCalled = expect
        // act
        selectionGenre.onNext(IndexPath(row: 0, section: 0))
        textSearch.onNext("")
        selectionGenre.onNext(IndexPath(row: 1, section: 0))
        
        // expect
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_loadTrigger_getMoviesList_failedShowError() {
       
        let moviesListReturn = PublishSubject<PagingInfo<SearchResultModel>>()
        usecase.movieListReturn = moviesListReturn.asObserver()
        
        // act
        textSearch.onNext("")
        selectionGenre.onNext(IndexPath(row: 0, section: 0))
        loadTrigger.onNext(())
        moviesListReturn.onError(TestError())
        let error = try! output.error.toBlocking().first()
        
        // expect
        XCTAssert(error is TestError)
    }
    
    func test_editText_searchByKeyword_faildedShowError() {
        let moviesListReturn = PublishSubject<PagingInfo<SearchResultModel>>()
        usecase.movieListReturn = moviesListReturn.asObserver()
        
        // act
        selectionGenre.onNext(IndexPath(row: 0, section: 0))
        textSearch.onNext("Foo")
        
        moviesListReturn.onError(TestError())
        let error = try! output.error.toBlocking().first()
        
        // expect
        XCTAssert(error is TestError)
    }
    
}
