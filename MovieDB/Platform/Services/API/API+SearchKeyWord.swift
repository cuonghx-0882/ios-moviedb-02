//
//  API+SearchKeyWord.swift
//  MovieDB
//
//  Created by cuonghx on 6/17/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import ObjectMapper

extension API {
    func getKeyWord(input: GetKeyWordInput) -> Observable<GetKeyWordOutput> {
        return request(input)
    }
}

extension API {
    final class GetKeyWordInput: APIInputBase {
        init(keyword: String) {
            let params: [String: Any] = [
                "api_key": Keys.apiKey,
                "query": keyword
            ]
            super.init(urlString: Urls.keywordURL,
                       parameters: params,
                       requestType: .get,
                       requireAccessToken: false)
        }
    }
    
    final class GetKeyWordOutput: APIOutputBase {
        private(set) var keywords: [KeyWord]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            keywords <- map["results"]
        }
    }
}
