//
//  DetailViewModelTests.swift
//  MovieDBTests
//
//  Created by cuonghx on 6/20/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import XCTest

@testable import MovieDB

// swiftlint:disable force_try
final class DetailViewModelTests: XCTestCase {
    
    private var usecase: DetailUseCaseMock!
    private var navigator: DetailNavigatorMock!
    private var viewModel: DetailViewModel!
    private var movie: Movie!
    
    private var input: DetailViewModel.Input!
    private var output: DetailViewModel.Output!
    
    private let disposeBage = DisposeBag()
    
    private let triggerLoadActor = PublishSubject<Void>()
    private let triggerLoadCompany = PublishSubject<Void>()
    private let triggerLoadTrailerLink = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        usecase = DetailUseCaseMock()
        navigator = DetailNavigatorMock()
        movie = Movie().with {
            $0.id = 1
        }
        viewModel = DetailViewModel(usecase: usecase,
                                    navigator: navigator,
                                    movie: movie)
        input = DetailViewModel.Input(triggerLoadActor: triggerLoadActor
                                        .asDriverOnErrorJustComplete(),
                                      triggerLoadCompany: triggerLoadCompany
                                        .asDriverOnErrorJustComplete(),
                                      triggerLoadTrailerLink: triggerLoadTrailerLink
                                        .asDriverOnErrorJustComplete())
        output = viewModel.transform(input)
        output.actorList
            .drive()
            .disposed(by: rx.disposeBag)
        output.companyList
            .drive()
            .disposed(by: rx.disposeBag)
        output.error
            .drive()
            .disposed(by: rx.disposeBag)
        output.trailerLink
            .drive()
            .disposed(by: rx.disposeBag)
        output.movie
            .drive()
            .disposed(by: rx.disposeBag)
        output.loadingTrailer
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    func test_getActorListCalled() {
        
        //act
        triggerLoadActor.onNext(())
        let actors = try! output.actorList.toBlocking().first()
        
        // assert
        XCTAssertTrue(usecase.getActorListCalled)
        XCTAssertEqual(usecase.movieID, movie.id)
        XCTAssertEqual(actors?.count, 1)
    }
    
    func test_getCompanyListCalled() {
        
        // act
        triggerLoadCompany.onNext(())
        let companies = try! output.companyList.toBlocking().first()
        
        // assert
        XCTAssertTrue(usecase.getProductCompany)
        XCTAssertEqual(usecase.movieID, movie.id)
        XCTAssertEqual(companies?.count, 1)
    }
    
    func test_getTrailerLinkCalled() {
        
        //act
        triggerLoadTrailerLink.onNext(())
        let link = try! output.trailerLink.toBlocking().first()
        
        // assert
        XCTAssertTrue(usecase.getTrailerLinkCalled)
        XCTAssertEqual(usecase.movieID, movie.id)
        XCTAssertEqual(link, "Foo")
    }
    
    func test_getActorListCalled_failedShowError() {
        let actorsReturn = PublishSubject<[Actor]>()
        usecase.listActorReturn = actorsReturn

        // act
        triggerLoadActor.onNext(())
        actorsReturn.onError(TestError())
        let error = try! output.error.toBlocking().first()
        
        // assert
        XCTAssert(error is TestError)
    }
    
    func test_getCompanyListCalled_failedShowError() {
        let companiessReturn = PublishSubject<[Company]>()
        usecase.listProductionCompanyReturn = companiessReturn
        
        // act
        triggerLoadCompany.onNext(())
        companiessReturn.onError(TestError())
        let error = try! output.error.toBlocking().first()
        
        // assert
        XCTAssert(error is TestError)
    }
    
    func test_getTrailerLinkCalled_failedShowError() {
        let trailerLinkReturn = PublishSubject<String>()
        usecase.trailerLinkReturn = trailerLinkReturn
        
        // act
        triggerLoadTrailerLink.onNext(())
        trailerLinkReturn.onError(TestError())
        let error = try! output.error.toBlocking().first()
        
        // assert
        XCTAssert(error is TestError)
    }
}
