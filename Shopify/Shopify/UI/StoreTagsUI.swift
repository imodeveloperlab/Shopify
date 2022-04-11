//
//  StoreUIAPI.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import DSKit

class StoreTagsUI {
    
    let tags = StoreTagsAPI()
    
    /// Get product types
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getProductTags(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        tags.getTags(first: 100, success: { tags in
            
            let viewModels = tags.map { tag -> DSViewModel in
                let composer = DSTextComposer()
                composer.add(type: .headlineWithSize(15), text: tag.lowercased().capitalized)
                var action = composer.actionViewModel()
                action.object = tag as AnyObject
                return action
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get product types
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getProductTagsForGallery(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = TagViewModels()
        
        tags.getTags(first: 100, success: { tags in
            
            let viewModels = tags.map { tag -> DSViewModel in
                ui.galleryTag(title: tag.readableString(), object: tag as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
}
