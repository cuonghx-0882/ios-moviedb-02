//
//  RealmRepository.swift
//  MovieDB
//
//  Created by cuonghx on 6/24/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Realm
import RealmSwift
import RxRealm

protocol RealmRepository {

}

extension RealmRepository {
    fileprivate func withRealm<T>(_ operation: String,
                                  action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch {
            print("Failed \(operation) realm )")
            return nil
        }
    }
    
    func getAllItem<T: Object>() -> Observable<[T]> {
        let result = withRealm("get all") { realm -> Observable<[T]> in
            let object = realm.objects(T.self)
            return Observable.collection(from: object)
                .map {
                    $0.toArray()
                }
        }
        return result ?? .empty()
    }
    
    func add<T: Object>(item: T) -> Observable<T> {
        let result = withRealm("add new item") { realm -> Observable<T> in
            try realm.write {
                realm.add(item)
            }
            return .just(item)
        }
        return result ?? .error(RealmError.addFail)
    }
    
    func delete<T: Object>(item: T) -> Observable<Void> {
        let result = withRealm("delete") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(item)
            }
            return .empty()
        }
        return result ?? .error(RealmError.deleteFail)
    }

    func toggle<T: Object>(item: T) -> Observable<Void> {
        let result = withRealm("toggle") { realm -> Observable<Void> in
            guard let primaryKey = T.primaryKey(),
                realm.object(ofType: T.self,
                             forPrimaryKey: item.value(forKey: primaryKey)) != nil else {
                                return add(item: item).mapToVoid()
            }
            return delete(item: item)
        }
        return result ?? .empty()
    }

    func tracking<T: Object>(item: T)-> Observable<Bool> {
        let result = withRealm("tracking") { realm -> Observable<Bool> in
            let object = realm.objects(T.self)
            return Observable.collection(from: object)
                .map { results in
                    guard let primaryKey = T.primaryKey(),
                        let primaryValue = item.value(forKey: primaryKey) as? Int else {
                            return false
                    }
                    return !results.filter("id == %@",
                                           primaryValue).isEmpty
                }
        }
        return result ?? .empty()
    }
}
