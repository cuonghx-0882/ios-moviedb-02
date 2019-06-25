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
    
    associatedtype ModelRealm
    associatedtype ModelType
    
    static func map(from item: ModelType, to: ModelRealm)
    static func item(from: ModelRealm) -> ModelType?
}

protocol ModelRealmableType {
   
    associatedtype PrimaryKey
    
    var valuePrimaryKey: PrimaryKey { get }
}

extension RealmRepository where ModelRealm: Object, ModelType: ModelRealmableType {
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
    
    func all() -> Observable<Results<ModelRealm>> {
        let result = withRealm("get all") { realm -> Observable<Results<ModelRealm>> in
            let realm = try Realm()
            let object = realm.objects(ModelRealm.self)
            return .collection(from: object)
        }
        return result ?? .empty()
    }
    
    func add(item: ModelType) -> Observable<Void> {
        let result = withRealm("add new item") { realm -> Observable<Void> in
            guard realm.object(ofType: ModelRealm.self,
                               forPrimaryKey: item.valuePrimaryKey) == nil else {
                                return .error(RealmError.itemExist)
            }
            try realm.write {
                let model = ModelRealm()
                Self.map(from: item, to: model)
                realm.add(model)
            }
            return .empty()
        }
        return result ?? .error(RealmError.addFail)
    }
    
    func delete(item: ModelType) -> Observable<Void> {
        let result = withRealm("delete") { realm -> Observable<Void> in
            guard let object = realm.object(ofType: ModelRealm.self,
                                            forPrimaryKey: item.valuePrimaryKey) else {
                                                return .error(RealmError.deleteFail)
            }
            try realm.write({
                realm.delete(object)
            })
            return .empty()
        }
        return result ?? .error(RealmError.deleteFail)
    }
    
    func toggle(item: ModelType) -> Observable<Void> {
        let result = withRealm("toggle") { realm -> Observable<Void> in
            guard realm.object(ofType: ModelRealm.self,
                               forPrimaryKey: item.valuePrimaryKey) != nil else {
                                                return add(item: item)
            }
            return delete(item: item)
        }
        return result ?? .empty()
    }
    
    func tracking(item: ModelType)-> Observable<Bool> {
        let result = withRealm("tracking") { realm -> Observable<Bool> in
            let realm = try Realm()
            let object = realm.objects(ModelRealm.self)
            return Observable.collection(from: object)
                .map { results in
                    return !results.filter("id == %@",
                                           item.valuePrimaryKey).isEmpty
                }
        }
        return result ?? .empty()
    }
}
