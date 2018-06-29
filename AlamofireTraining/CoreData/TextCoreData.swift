//
//  TextCoreData.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/29/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import CoreData


@objc(TextCoreData)
class TextCoreData : NSManagedObject {
    @NSManaged public var text: String
}

extension TextCoreData: CoreDataParseable {
    typealias T = TextCoreData
    
    static var entityName: String {
        return String(describing: TextCoreData.self)
    }
    
    static func findIfExists(dict: [String : Any], completion: @escaping (TextCoreData?) -> ()) {
        guard let data = dict[TextCoreDataAPIKeys.text] as? String else {
            completion(nil)
            return
        }
        let predicate = NSPredicate(format: "text == %i", data)
        CoreDataService.getSharedInstance().fetch(entityName: self.entityName, predicate: predicate) { (texts) in
            guard let text = texts.first as? TextCoreData else {
                completion(nil)
                return
            }
            
            completion(text)
        }
    }
    
    static func create(dict: [String : Any], completion: @escaping (TextCoreData?) -> ()) {
        if let text = dict[TextCoreDataAPIKeys.text] as? String {
            var coreDataDict: [String: Any] = [:]
            coreDataDict[TextCoreDataKeys.text] = text
            
            CoreDataService.getSharedInstance().save(entityName: self.entityName, info: coreDataDict) { (texts) in
                guard let text = texts as? TextCoreData else {
                    completion(nil)
                    return
                }
                completion(text)
            }
        } else {
            completion(nil)
        }
    }
    
    func merge(dict: [String : Any], completion: @escaping (Bool) -> ()) {
        let context = CoreDataService.getSharedInstance().getTempManagedObjectContext()
        context.perform {
            if let text = dict[TextCoreDataAPIKeys.text] as? String {
                var propertyDidChange = false
                if self.text != text {
                    self.text = text
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
