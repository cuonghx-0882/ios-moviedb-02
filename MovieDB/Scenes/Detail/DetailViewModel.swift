//
//  DetailViewModel.swift
//  Project2
//
//  Created by cuonghx on 6/15/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import RxDataSources

typealias ActorSection = SectionModel<String, Actor>
typealias CompanySection = SectionModel<String, Company>

struct DetailViewModel {
    var usecase: DetailUseCaseType
    var navigator: DetailNavigatorType
    var movie: Movie
}

extension DetailViewModel: ViewModelType {
    struct Input {
        var triggerLoadActor: Driver<Void>
        var triggerLoadCompany: Driver<Void>
        var triggerLoadTrailerLink: Driver<Void>
    }
    
    struct Output {
        var movie: Driver<Movie>
        var trailerLink: Driver<String>
        var actorList: Driver<[ActorSection]>
        var companyList: Driver<[CompanySection]>
        var error: Driver<Error>
        var loadingTrailer: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let indicatorTrailerLink = ActivityIndicator()
        
        let trailerLink = input.triggerLoadTrailerLink
            .flatMapLatest {
                self.usecase
                    .getTrailerLink(movieID: self.movie.id)
                    .trackError(errorTracker)
                    .trackActivity(indicatorTrailerLink)
                    .asDriverOnErrorJustComplete()
            }
        
        let companyList = input.triggerLoadCompany
            .flatMapLatest {
                self.usecase
                    .getProductionCompanyList(movieID: self.movie.id)
                    .trackError(errorTracker)
                    .map {
                        [CompanySection(model: "",
                                        items: $0)]
                    }
                    .asDriverOnErrorJustComplete()
            }
        
        let actorList = input.triggerLoadActor
            .flatMapLatest {
                self.usecase
                    .getActorList(movieID: self.movie.id)
                    .trackError(errorTracker)
                    .map {
                        [ActorSection(model: "",
                                      items: $0)]
                    }
                    .asDriverOnErrorJustComplete()
            }
        
        return Output(movie: Driver.just(movie),
                      trailerLink: trailerLink,
                      actorList: actorList,
                      companyList: companyList,
                      error: errorTracker.asDriver(),
                      loadingTrailer: indicatorTrailerLink.asDriver())
    }
}
