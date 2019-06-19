//
//  Utils.swift
//  MovieDB
//
//  Created by cuonghx on 6/18/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

enum Utils {
    static func getGenreList(genres: [Int]) -> String {
        guard !genres.isEmpty else { return "" }
        return genres
            .compactMap {
                Constants.genres[$0]
            }
            .joined(separator: ", ")
    }
}
