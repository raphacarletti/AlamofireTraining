//
//  CoreDataService.swift
//  Created by Raphael Carletti on 28/06/2018.
//
//

import UIKit
import CoreData

class CoreDataService {
    
    // MARK: - Singleton
    private static var sharedInstance: CoreDataService? = nil
    
    private init() {}
    
    static func getSharedInstance() -> CoreDataService {
        guard let checkedSharedInstance = self.sharedInstance else {
            let newInstance = CoreDataService()
            self.sharedInstance = newInstance
            
            return newInstance
        }
        
        return checkedSharedInstance
    }
    
    // MARK: - Properties
    private let modelName: String = "AlamofireTraining"
    
    
    // MARK: - Core Data Stack
    private(set) lazy var masterManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.parent = self.masterManagedObjectContext
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: - Initialization
    
    func getTempManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        managedObjectContext.parent = self.mainManagedObjectContext
        
        return managedObjectContext
    }
    
    func saveTempContext(context: NSManagedObjectContext, completion: @escaping (_ success: Bool)->()) throws {
        do {
            try context.save()
            self.saveMainContext(completion: completion)
        } catch let error {
            print("Error saving in temp context")
            completion(false)
            throw error
        }
    }
    
    func saveMainContext(completion: @escaping (_ success: Bool)->()) {
        self.mainManagedObjectContext.perform {
            do {
                try self.mainManagedObjectContext.save()
                self.saveMasterContext(completion: completion)
            } catch {
                print("Error saving in main context")
                completion(false)
            }
        }
    }
    
    func saveMasterContext(completion: @escaping (_ success: Bool)->()) {
        self.masterManagedObjectContext.perform {
            do {
                try self.masterManagedObjectContext.save()
                completion(true)
            } catch {
                print("Error saving in master context")
                completion(false)
            }
        }
    }
    
    func save(entityName: String, info dict: [String : Any], completion: @escaping (NSManagedObject?)->()) {
        let context = CoreDataService.getSharedInstance().getTempManagedObjectContext()
        context.perform {
            let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
//                print("Could not retrieve context")
//                completion(nil)
//                return
//            }
            
//            let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
            let coreDataObject = entity
            for (key, value) in dict {
                coreDataObject.setValue(value, forKey: key)
            }
            
            do {
                try context.obtainPermanentIDs(for: [coreDataObject])
                try CoreDataService.getSharedInstance().saveTempContext(context: context, completion: { (success) in
                    if success {
                        self.getObjectWith(objectID: coreDataObject.objectID) { (object) in
                            completion(object)
                        }
                    } else {
                        completion(nil)
                    }
                })
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                //FIXME: Should return nil?
                completion(nil)
            }
        }
    }
    
    func delete(object: NSManagedObject) {
        let context = CoreDataService.getSharedInstance().masterManagedObjectContext
        
        context.delete(object)
        CoreDataService.getSharedInstance().saveMasterContext { (success) in
            
        }
        
    }
    
    func fetch(entityName: String, predicate: NSPredicate? = nil, completion: @escaping ([NSManagedObject])->()) {
        let context = self.getTempManagedObjectContext()
        
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = predicate
            
            do {
                let objects = try context.fetch(fetchRequest)
                self.getObjectsWith(objects: objects, completion: { (objects) in
                    guard let objects = objects else {
                        completion([])
                        return
                    }
                    completion(objects)
                })
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion([])
            }
        }
    }
    
    func getEntityCount(entityName: String, completion: @escaping (Int)->()) {
        let context = CoreDataService.getSharedInstance().masterManagedObjectContext
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            do {
                let numberOfEntity = try context.count(for: fetchRequest)
                completion(numberOfEntity)
            } catch let error as NSError {
                print("Description: \(error.localizedDescription) Code: \(error.code)")
                completion(-1)
            }
        }
    }
    
    func deleteAll(completion: @escaping (Bool)->()) {
        let context = self.getTempManagedObjectContext()
        context.perform {
            var deleteRequestArray : [NSBatchDeleteRequest] = []
            deleteRequestArray.append(NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: UserCoreData.entityName)))
            deleteRequestArray.append(NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: PersonCoreData.entityName)))
            deleteRequestArray.append(NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: TextCoreData.entityName)))
            
            self.printAllCoreDataEntityCounts()
            do {
                for deleteRequest in deleteRequestArray {
                    try context.execute(deleteRequest)
                }
                try self.saveTempContext(context: context, completion: { (success) in
                    completion(success)
                })
            } catch let error as NSError {
                print("Delete all error: \(error)")
            }
            self.printAllCoreDataEntityCounts()
        }
    }
    
    func printAllCoreDataEntityCounts() {
        print("All Core Data Entities Count:")
        self.getEntityCount(entityName: UserCoreData.entityName) { (number) in
            print("User:         \(number)")
        }
        self.getEntityCount(entityName: PersonCoreData.entityName) { (number) in
            print("Person:       \(number)")
        }
        self.getEntityCount(entityName: TextCoreData.entityName) { (number) in
            print("Text:         \(number)")
        }
    }
    
    func getObjectWith(objectID: NSManagedObjectID, completion: @escaping (_ object: NSManagedObject?)->()) {
        self.masterManagedObjectContext.perform {
            do {
                let object = try self.masterManagedObjectContext.existingObject(with: objectID)
                completion(object)
            } catch {
                completion(nil)
            }
        }
    }
    
    func getObjectsWith(objects: [NSManagedObject], completion: @escaping (_ object: [NSManagedObject]?)->()) {
        self.masterManagedObjectContext.perform {
            var masterObjects: [NSManagedObject] = []
            for managedObject in objects {
                do {
                    let object = try self.masterManagedObjectContext.existingObject(with: managedObject.objectID)
                    masterObjects.append(object)
                } catch {
                    print("Error getting object from master context")
                }
            }
            completion(masterObjects)
        }
    }
}
