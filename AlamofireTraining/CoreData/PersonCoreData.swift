//
//  PersonCoreData.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 7/2/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import CoreData


@objc(PersonCoreData)
class PersonCoreData : NSManagedObject {
    @NSManaged public var address: String
    @NSManaged public var bio: String
    @NSManaged public var city: String
    @NSManaged public var country: String
    @NSManaged public var email: String
    @NSManaged public var firstName: String
    @NSManaged public var ipAddress: String
    @NSManaged public var lastName: String
    @NSManaged public var name: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var timeZone: String
    @NSManaged public var title: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}

extension PersonCoreData: CoreDataParseable {
    typealias T = PersonCoreData
    
    static var entityName: String {
        return String(describing: PersonCoreData.self)
    }
    
    static func findIfExists(dict: [String : Any], completion: @escaping (PersonCoreData?) -> ()) {
        guard let data = dict[AlamofireConstants.data] as? [String: Any], let name = data[PersonCoreDataAPIKeys.name] as? String else {
            completion(nil)
            return
        }
        let predicate = NSPredicate(format: "name == %@", name)
        CoreDataService.getSharedInstance().fetch(entityName: self.entityName, predicate: predicate) { (people) in
            guard let person = people.first as? PersonCoreData else {
                completion(nil)
                return
            }
            
            completion(person)
        }
    }
    
    static func create(dict: [String : Any], completion: @escaping (PersonCoreData?) -> ()) {
        var coreDataDict: [String: Any] = [:]
        guard let dict = dict[AlamofireConstants.data] as? [String: Any] else {
            completion(nil)
            return
        }
        if let name = dict[PersonCoreDataAPIKeys.name] as? String {
            coreDataDict[PersonCoreDataKey.name] = name
        }
        if let address = dict[PersonCoreDataAPIKeys.address] as? String {
            coreDataDict[PersonCoreDataKey.address] = address
        }
        if let email = dict[PersonCoreDataAPIKeys.email] as? String {
            coreDataDict[PersonCoreDataKey.email] = email
        }
        if let bio = dict[PersonCoreDataAPIKeys.bio] as? String {
            coreDataDict[PersonCoreDataKey.bio] = bio
        }
        if let city = dict[PersonCoreDataAPIKeys.city] as? String {
            coreDataDict[PersonCoreDataKey.city] = city
        }
        if let country = dict[PersonCoreDataAPIKeys.country] as? String {
            coreDataDict[PersonCoreDataKey.country] = country
        }
        if let firstName = dict[PersonCoreDataAPIKeys.firstName] as? String {
            coreDataDict[PersonCoreDataKey.firstName] = firstName
        }
        if let lastName = dict[PersonCoreDataAPIKeys.lastName] as? String {
            coreDataDict[PersonCoreDataKey.lastName] = lastName
        }
        if let ipAddress = dict[PersonCoreDataAPIKeys.ipAddress] as? String {
            coreDataDict[PersonCoreDataKey.ipAddress] = ipAddress
        }
        if let phoneNumber = dict[PersonCoreDataAPIKeys.phoneNumber] as? String {
            coreDataDict[PersonCoreDataKey.phoneNumber] = phoneNumber
        }
        if let timeZone = dict[PersonCoreDataAPIKeys.timeZone] as? String {
            coreDataDict[PersonCoreDataKey.ipAddress] = timeZone
        }
        if let title = dict[PersonCoreDataAPIKeys.title] as? String {
            coreDataDict[PersonCoreDataKey.title] = title
        }
        if let latitude = dict[PersonCoreDataAPIKeys.latitude] as? Double {
            coreDataDict[PersonCoreDataKey.latitude] = latitude
        }
        if let longitude = dict[PersonCoreDataAPIKeys.longitude] as? Double {
            coreDataDict[PersonCoreDataKey.longitude] = longitude
        }
        
        CoreDataService.getSharedInstance().save(entityName: self.entityName, info: coreDataDict) { (person) in
            guard let person = person as? PersonCoreData else {
                completion(nil)
                return
            }
            completion(person)
        }
    }
    
    func merge(dict: [String : Any], completion: @escaping (Bool) -> ()) {
        let context = CoreDataService.getSharedInstance().getTempManagedObjectContext()
        context.perform {
            guard let dict = dict[AlamofireConstants.data] as? [String: Any] else {
                completion(false)
                return
            }
            var propertyDidChange = false
            if let name = dict[PersonCoreDataAPIKeys.name] as? String, self.name != name {
                self.name = name
                propertyDidChange = true
            }
            if let address = dict[PersonCoreDataAPIKeys.address] as? String {
                self.address = address
                propertyDidChange = true
            }
            if let email = dict[PersonCoreDataAPIKeys.email] as? String {
                self.email = email
                propertyDidChange = true
            }
            if let bio = dict[PersonCoreDataAPIKeys.bio] as? String {
                self.bio = bio
                propertyDidChange = true
            }
            if let city = dict[PersonCoreDataAPIKeys.city] as? String {
                self.city = city
                propertyDidChange = true
            }
            if let country = dict[PersonCoreDataAPIKeys.country] as? String {
                self.country = country
                propertyDidChange = true
            }
            if let firstName = dict[PersonCoreDataAPIKeys.firstName] as? String {
                self.firstName = firstName
                propertyDidChange = true
            }
            if let lastName = dict[PersonCoreDataAPIKeys.lastName] as? String {
                self.lastName = lastName
                propertyDidChange = true
            }
            if let ipAddress = dict[PersonCoreDataAPIKeys.ipAddress] as? String {
                self.ipAddress = ipAddress
                propertyDidChange = true
            }
            if let phoneNumber = dict[PersonCoreDataAPIKeys.phoneNumber] as? String {
                self.phoneNumber = phoneNumber
                propertyDidChange = true
            }
            if let timeZone = dict[PersonCoreDataAPIKeys.timeZone] as? String {
                self.timeZone = timeZone
                propertyDidChange = true
            }
            if let title = dict[PersonCoreDataAPIKeys.title] as? String {
                self.title = title
                propertyDidChange = true
            }
            if let latitude = dict[PersonCoreDataAPIKeys.latitude] as? Double {
                self.latitude = latitude
                propertyDidChange = true
            }
            if let longitude = dict[PersonCoreDataAPIKeys.longitude] as? Double {
                self.longitude = longitude
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
