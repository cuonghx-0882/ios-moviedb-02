//
//  APISearchKeyWordTests.swift
//  MovieDBTests
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import XCTest
import Mockingjay
@testable import MovieDB

// swiftlint:disable force_try
final class APISearchKeyWordTests: XCTestCase {
    var moviesURL = API.Urls.keywordURL
    var queries = "?api_key=7345489e9522a18a9b84bbc90f4d7758&query=fast"
    
    func test_APISearchKeyWord_Success() {
        // arranger
        let output: API.GetKeyWordOutput?
        let data = loadStub(name: "keyword", extension: "json")
        let stubURL = moviesURL + queries
        
        // act
        stub(uri(stubURL), jsonData(data as Data))
        let input = API.GetKeyWordInput(keyword: "fast")
        output = try! API.shared.getKeyWord(input: input).toBlocking().first()
        
        // assert
        XCTAssertNotNil(output?.keywords)
        XCTAssertTrue(output?.keywords?.first?.id == 6_525)
    }
}
