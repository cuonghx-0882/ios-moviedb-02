//
//  FavoriteRepositoryTests.swift
//  MovieDBTests
//
//  Created by cuonghx on 6/25/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import XCTest
import RealmSwift

@testable import MovieDB

// swiftlint:disable force_try force_unwrapping
final class FavoriteRepositoryTests: XCTestCase {
    
    var repository: FavoriteRepositoryType!
    
    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        repository = FavoriteRepository()
    }
    
    func test_toggleMovie_NotInFavorite_Added() {
        
        _ = repository.toggle(Movie().with { $0.id = 1 })
        
        let movies = try! repository.getAll().toBlocking().first()
        
        XCTAssert(movies?.count == 1)
    }
    
    func test_toggleMovie_ExistInFavorite_RemoveFromFavorite() {
        
        _ = repository.toggle(Movie().with { $0.id = 1 })
        _ = repository.toggle(Movie().with { $0.id = 1 })
        
        let movies = try! repository.getAll().toBlocking().first()
    
        XCTAssertEqual(movies?.count, 0)
    }
    
    func test_trackingMovie_ExistInFavorite_ReturnTrue() {
        let movie = Movie().with { $0.id = 1 }
        
        _ = repository.toggle(movie)
        let tracker = try! repository.tracking(movie).toBlocking().first()
        
        XCTAssert(tracker!)
    }
    
    func test_trackingMovie_NotExistInFavorite_ReturnFalse() {
        let movie = Movie().with { $0.id = 1 }
        
        let tracker = try! repository.tracking(movie).toBlocking().first()
        
        XCTAssertFalse(tracker!)
    }
}
