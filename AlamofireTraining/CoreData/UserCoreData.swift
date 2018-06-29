//
//  UserCoreData.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/28/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import CoreData


@objc(UserCoreData)
class UserCoreData : NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var role: Int16
    @NSManaged public var status: Int16
    @NSManaged public var id: Int16
    @NSManaged public var accessToken: String
    @NSManaged public var createdAt: Int32
    @NSManaged public var updatedAt: Int32
}

extension UserCoreData: CoreDataParseable {
    typealias T = UserCoreData
    
    static var entityName: String {
        return String(describing: UserCoreData.self)
    }
    
    static func findIfExists(dict: [String : Any], completion: @escaping (UserCoreData?) -> ()) {
        guard let data = dict[AlamofireConstants.data] as? [String: Any], let userId = data[UserCoreDataAPIKeys.id] as? Int16 else {
            completion(nil)
            return
        }
        let predicate = NSPredicate(format: "id == %i", userId)
        CoreDataService.getSharedInstance().fetch(entityName: self.entityName, predicate: predicate) { (users) in
            guard let user = users.first as? UserCoreData else {
                completion(nil)
                return
            }
            
            completion(user)
        }
    }
    
    static func create(dict: [String : Any], completion: @escaping (UserCoreData?) -> ()) {
        if let dict = dict[AlamofireConstants.data] as? [String: Any] {
            var coreDataDict: [String: Any] = [:]
            if let name = dict[UserCoreDataAPIKeys.name] as? String {
                coreDataDict[UserCoreDataKey.name] = name
            }
            if let email = dict[UserCoreDataAPIKeys.email] as? String {
                coreDataDict[UserCoreDataKey.email] = email
            }
            if let accessToken = dict[UserCoreDataAPIKeys.accessToken] as? String {
                coreDataDict[UserCoreDataKey.accessToken] = accessToken
            }
            if let role = dict[UserCoreDataAPIKeys.role] as? Int16 {
                coreDataDict[UserCoreDataKey.role] = role
            }
            if let status = dict[UserCoreDataAPIKeys.status] as? Int16 {
                coreDataDict[UserCoreDataKey.status] = status
            }
            if let id = dict[UserCoreDataAPIKeys.id] as? Int16 {
                coreDataDict[UserCoreDataKey.id] = id
            }
            if let createdAt = dict[UserCoreDataAPIKeys.createdAt] as? Int32 {
                coreDataDict[UserCoreDataKey.createdAt] = createdAt
            }
            if let updatedAt = dict[UserCoreDataAPIKeys.updatedAt] as? Int32 {
                coreDataDict[UserCoreDataKey.updatedAt] = updatedAt
            }
            
            CoreDataService.getSharedInstance().save(entityName: self.entityName, info: coreDataDict) { (user) in
                guard let user = user as? UserCoreData else {
                    completion(nil)
                    return
                }
                completion(user)
            }
        }
    }
    
    func merge(dict: [String : Any], completion: @escaping (Bool) -> ()) {
        let context = CoreDataService.getSharedInstance().getTempManagedObjectContext()
        context.perform {
            if let dict = dict[AlamofireConstants.data] as? [String: Any] {
                var propertyDidChange = false
                if let name = dict[UserCoreDataAPIKeys.name] as? String, self.name != name {
                    self.name = name
                    propertyDidChange = true
                }
                if let email = dict[UserCoreDataAPIKeys.email] as? String, self.email != email {
                    self.email = email
                    propertyDidChange = true
                }
                if let accessToken = dict[UserCoreDataAPIKeys.accessToken] as? String, self.accessToken != accessToken {
                    self.accessToken = accessToken
                    propertyDidChange = true
                }
                if let role = dict[UserCoreDataAPIKeys.role] as? Int16, self.role != role {
                    self.role = role
                    propertyDidChange = true
                }
                if let status = dict[UserCoreDataAPIKeys.status] as? Int16, self.status != status {
                    self.status = status
                    propertyDidChange = true
                }
                if let updatedAt = dict[UserCoreDataAPIKeys.updatedAt] as? Int32, self.updatedAt != updatedAt {
                    self.updatedAt = updatedAt
                    propertyDidChange = true
                }
                if propertyDidChange {
                    do {
                        try CoreDataService.getSharedInstance().saveTempContext(context: context, completion: { (success) in
                            completion(success)
                        })
                    } catch {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
}
