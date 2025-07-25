//
//  ProductManagedObject+CoreDataProperties.swift
//  
//
//  Created by wafaa farrag on 25/07/2025.
//
//

import Foundation
import CoreData


extension ProductManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductManagedObject> {
        return NSFetchRequest<ProductManagedObject>(entityName: "ProductManagedObject")
    }

    @NSManaged public var category: String?
    @NSManaged public var count: Int64
    @NSManaged public var desc: String?
    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var title: String?

}
