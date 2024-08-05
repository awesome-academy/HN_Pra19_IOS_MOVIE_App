//
//  CoreDataUtils.swift
//  HN_Pra19_IOS_Movie_App
//
//  Created by Khánh Vũ on 5/8/24.
//

import Foundation
import CoreData
import UIKit

final class CoreDataUtils {
    static let shared = CoreDataUtils()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DB")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    public lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainManagedObjectContext
        return privateContext
    }()
    
    private func saveMainContext() {
        if mainManagedObjectContext.hasChanges {
            do {
                try mainManagedObjectContext.save()
            } catch {
                print("Error saving main managed object context: \(error)")
            }
        }
    }
    
    private func savePrivateContext() {
        if privateManagedObjectContext.hasChanges {
            do {
                try privateManagedObjectContext.save()
            } catch {
                print("Error saving private managed object context: \(error)")
            }
        }
    }
    
    private func saveChanges() {
        savePrivateContext()
        mainManagedObjectContext.performAndWait {
            saveMainContext()
        }
    }
    
    func saveData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.performAndWait {
            // Insert the objects into the private context
            for object in objects {
                self.privateManagedObjectContext.insert(object)
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func updateData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.perform {
            // Update the objects in the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    // If the object is already in the private context, update it directly
                    object.managedObjectContext?.refresh(object, mergeChanges: true)
                } else {
                    // If the object is not in the private context, fetch and update it
                    let fetchRequest = NSFetchRequest<T>(entityName: object.entity.name!)
                    fetchRequest.predicate = NSPredicate(format: "SELF == %@", object)
                    fetchRequest.fetchLimit = 1
                    
                    if let fetchedObject = try? self.privateManagedObjectContext.fetch(fetchRequest).first {
                        fetchedObject.setValuesForKeys(object.dictionaryWithValues(forKeys: object.entity.attributesByName.keys.map { $0.description }))
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
    
    func deleteData<T: NSManagedObject>(objects: [T]) {
        privateManagedObjectContext.performAndWait {
            // Delete the objects from the private context
            for object in objects {
                if object.managedObjectContext == self.privateManagedObjectContext {
                    self.privateManagedObjectContext.delete(object)
                } else {
                    if let objectInContext = self.privateManagedObjectContext.object(with: object.objectID) as? T {
                        self.privateManagedObjectContext.delete(objectInContext)
                    }
                }
            }
            
            // Save changes to the private context and merge to the main context
            self.saveChanges()
        }
    }
}
