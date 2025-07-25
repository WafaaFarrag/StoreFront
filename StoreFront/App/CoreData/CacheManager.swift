//
//  CacheManager.swift
//  StoreFront
//
//  Created by wafaa farrag on 25/07/2025.
//

import Foundation
import CoreData

final class CacheManager {
    static let shared = CacheManager()

    private let context = PersistenceController.shared.viewContext
    
    // Save products to CoreData
    func saveProducts(_ products: [ProductModel]) {
        // Clear existing cache before saving new products
        clearCache()
        
        products.forEach { product in
            let entity = ProductManagedObject(context: context)
            entity.id = Int64(product.id)
            entity.title = product.title
            entity.price = product.price
            entity.desc = product.description
            entity.category = product.category
            entity.imageURL = product.image
            entity.rating = product.rating.rate
            entity.count = Int64(product.rating.count)
        }
        
        // Save the context to persist data
        do {
            try context.save()
            print("products saved in core data\(products)")
        } catch {
            print("Failed to save products to CoreData: \(error)")
        }
    }
    
    // Load cached products from CoreData
    func loadCachedProducts() -> [ProductModel] {
        let fetchRequest: NSFetchRequest<ProductManagedObject> = ProductManagedObject.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result.map {
                ProductModel(
                    id: Int($0.id),
                    title: $0.title ?? "",
                    price: $0.price,
                    description: $0.desc ?? "",
                    category: $0.category ?? "",
                    image: $0.imageURL ?? "",
                    rating: Rating(rate: $0.rating, count: Int($0.count))
                )
            }
        } catch {
            print("Failed to load cached products: \(error)")
            return []
        }
    }
    
    // Clear all cached products from CoreData
    private func clearCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductManagedObject.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear CoreData cache: \(error)")
        }
    }
}
