//
//  CoreDataStackPerson.swift
//  MyFinal
//
//  Created by Brittany Mason on 3/8/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

import CoreData

@objc(Person)
public class Person: NSManagedObject {
    
    static let title = "Person"
    
    
    convenience init(name: String, context: NSManagedObjectContext) {
      
        if let ent = NSEntityDescription.entity(forEntityName: Person.title, in: context) {
            self.init(entity: ent, insertInto: context)
            self.name = name
       
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
}

extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension Person {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
