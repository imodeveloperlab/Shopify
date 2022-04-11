//
//  StoreCollectionsUI.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import DSKit

class StoreCollectionsUI {
    
    let collections = StoreCollectionsAPI()
    
    /// Get collections
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getCollections(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = CollectionViewModels()
        
        collections.getCollections(first: 100, success: { collections in
            
            let viewModels = collections.map { collection -> DSViewModel in
                
                return ui.card(title: collection.title,
                               description: collection.description,
                               image: collection.image?.originalSrc,
                               object: collection.id.rawValue as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get list collections
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getCollectionsList(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = CollectionViewModels()
        
        collections.getCollections(first: 100, success: { collections in
            
            let viewModels = collections.map { collection -> DSViewModel in
                
                return ui.list(title: collection.title,
                               description: collection.description,
                               image: collection.image?.originalSrc,
                               object: collection.id.rawValue as AnyObject)
                
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get top collections
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getTopCollections(first: Int32, success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        collections.getCollections(first: first, success: { collections in
            
            let viewModels = collections.map { collection -> DSViewModel in
                
                let composer = DSTextComposer()
                composer.add(type: .headlineWithSize(14), text: collection.title.lowercased().capitalized)
                var action = composer.actionViewModel()
                action.rightNone()
                action.object = collection.id.rawValue as AnyObject
                
                return action
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get top collections
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getCollectionsForGallery(first: Int32, success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = TagViewModels()
        
        collections.getCollections(first: first, success: { collections in
            
            let viewModels = collections.map { collection -> DSViewModel in
                ui.galleryTag(title: collection.title.readableString(), object: collection.id.rawValue as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get collection collections
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getCollection(collectionID: CollectionID, success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = ProductViewModels()
        
        collections.getCollectionAndProducts(collectionID: collectionID, success: { response in
            
            let viewModels = response.products.map { product -> DSViewModel in
                ui.bigProduct(title: product.title,
                              description: product.description.maxLength(length: 45),
                              image: product.coverImage(),
                              price: product.firstPrice(),
                              object: product.id as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
}
