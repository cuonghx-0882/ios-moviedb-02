//
//  MovieRealm.swift
//  Project2
//
//  Created by cuonghx on 6/23/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import RealmSwift

final class MovieRealm: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title: String?
    @objc dynamic var overview: String?
    @objc dynamic var genres: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var voteAverage = 0.0
    @objc dynamic var posterPath: String?
    @objc dynamic var addDate = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
