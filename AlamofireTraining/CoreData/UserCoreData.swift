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
    @NSManaged public var id: String
    @NSManaged public var accessToken: String
}

extension UserCoreData: CoreDataParseable {
    typealias T = UserCoreData
    
    static var entityName: String {
        return String(describing: UserCoreData.self)
    }
    
    static func findIfExists(dict: [String : Any], completion: @escaping (UserCoreData?) -> ()) {
        guard let userId = dict[UserCoreDataKey.id] as? String else {
            completion(nil)
            return
        }
        let predicate = NSPredicate(format: "\(UserCoreDataKey.id) == %@", userId)
        CoreDataService.getSharedInstance().fetch(entityName: self.entityName, predicate: predicate) { (users) in
            guard let user = users.first as? UserCoreData else {
                completion(nil)
                return
            }
            
            completion(user)
        }
    }
    
    static func create(dict: [String : Any], completion: @escaping (UserCoreData?) -> ()) {
        
    }
    
    func merge(dict: [String : Any], completion: @escaping (Bool) -> ()) {
        
    }
}
