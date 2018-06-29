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
//        context.perform {
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                print("Could not retrieve context")
                completion(nil)
                return
            }
            
            let coreDataObject = NSManagedObject(entity: entity, insertInto: context)
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
//        }
    }
    
    func delete(object: NSManagedObject) {
        let context = CoreDataService.getSharedInstance().masterManagedObjectContext
        
        context.delete(object)
        CoreDataService.getSharedInstance().saveMasterContext { (success) in
            
        }
        
    }
    
    func fetch(entityName: String, predicate: NSPredicate? = nil, completion: @escaping ([NSManagedObject])->()) {
        let context = CoreDataService.getSharedInstance().masterManagedObjectContext
        
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = predicate
            
            do {
                let objects = try context.fetch(fetchRequest)
                completion(objects)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                completion([])
            }
        }
    }
    
    func getEntityCount(entityName: String) -> Int {
        let context = CoreDataService.getSharedInstance().masterManagedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            return try context.count(for: fetchRequest)
        } catch let error as NSError {
            print("Description: \(error.localizedDescription) Code: \(error.code)")
            return 0
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
}
