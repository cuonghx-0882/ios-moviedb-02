//
//  SearchViewModel.swift
//  MovieDB
//
//  Created by cuonghx on 6/21/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import RxDataSources

typealias ResultSearchSection = AnimatableSectionModel<String, SearchResultModel>

struct SearchViewModel {
    var usecase: SearchUseCaseType
    var navigator: SearchNavigatorType
}

extension SearchViewModel: ViewModelType {
    
    struct Input {
        var loadTrigger: Driver<Void>
        var loadMoreTrigger: Driver<Void>
        var refreshTrigger: Driver<Void>
        var selectionGenre: Driver<IndexPath>
        var textSearch: Driver<String>
        var selectionMovie: Driver<IndexPath>
    }
    
    struct Output {
        var fetchItems: Driver<Void>
        var error: Driver<Error>
        var loading: Driver<Bool>
        var refreshing: Driver<Bool>
        var loadingMore: Driver<Bool>
        var movieResult: Driver<[ResultSearchSection]>
        var clearSelectedGenre: Driver<Void>
        var clearTextInSearchBar: Driver<Void>
        var genresList: Driver<[GenreModel]>
        var gotoTop: Driver<Void>
        var selectedMovie: Driver<Movie>
        var isEmptyData: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        
        let errorTracker = ErrorTracker()

        let searchText = input.textSearch
            .debounce(0.5)
            .distinctUntilChanged()
        
        let search = searchText
            .withLatestFrom(input.selectionGenre) { ($0, $1) }
            .asObservable()
        
        let getItems: () -> Observable<PagingInfo<SearchResultModel>> = {
            return search
                .take(1)
                .flatMapLatest { arg -> Observable<PagingInfo<SearchResultModel>> in
                    let (query, index) = arg
                    if query.isEmpty {
                        return self.usecase
                            .getMovieBy(genre: self.usecase.getGenresID(index: index.row))
                            .trackError(errorTracker)
                    }
                    return self.usecase.getMovieBy(keyword: query)
                        .trackError(errorTracker)
                }
        }
        
        let loadMoreItems: (_ page: Int) -> Observable<PagingInfo<SearchResultModel>> = { page in
            return search
                .take(1)
                .flatMapLatest { arg -> Observable<PagingInfo<SearchResultModel>> in
                    let (query, index) = arg
                    if query.isEmpty {
                        return self.usecase
                            .loadMoreMovieBy(genre: self.usecase.getGenresID(index: index.row),
                                             page: page)
                            .trackError(errorTracker)
                    }
                    return self.usecase
                        .loadMoreMovieByKeyword(keyword: query,
                                                page: page)
                        .trackError(errorTracker)
                }
        }
        
        let loadTrigger = Driver.merge(input.loadTrigger,
                                       searchText.mapToVoid(),
                                       input.selectionGenre.mapToVoid())
        
        let loadMore = setupLoadMorePaging(loadTrigger: loadTrigger,
                                           getItems: getItems,
                                           refreshTrigger: input.refreshTrigger,
                                           refreshItems: getItems,
                                           loadMoreTrigger: input.loadMoreTrigger,
                                           loadMoreItems: loadMoreItems)
        let ( page, fetchItems, error, loading, refreshing, loadingMore ) = loadMore
        
        let movieResult = page.map {
            [ResultSearchSection(model: "",
                                 items: $0.items)]
        }
        .asDriverOnErrorJustComplete()
        
        let clearSelectedGenre = input.textSearch
            .filter { !$0.isEmpty }
            .mapToVoid()
        
        let movie = page
            .map { $0.items }
            .asDriverOnErrorJustComplete()
        
        let selectedMovie = input.selectionMovie
            .withLatestFrom(movie) { $1[$0.row].movie }
            .do(onNext: { movie in
                self.navigator.toDetailScreen(movie: movie)
            })
        let isEmptyData = checkIfDataIsEmpty(fetchItemsTrigger: fetchItems,
                                             loadTrigger: Driver.merge(loading,
                                                                       refreshing),
                                             items: movie)
        return Output(fetchItems: fetchItems,
                      error: Driver.merge(error, errorTracker.asDriver()),
                      loading: loading,
                      refreshing: refreshing,
                      loadingMore: loadingMore,
                      movieResult: movieResult,
                      clearSelectedGenre: clearSelectedGenre,
                      clearTextInSearchBar: input.selectionGenre
                        .mapToVoid(),
                      genresList: usecase
                        .getListGenres()
                        .asDriverOnErrorJustComplete(),
                      gotoTop: loadTrigger,
                      selectedMovie: selectedMovie,
                      isEmptyData: isEmptyData)
    }
}
