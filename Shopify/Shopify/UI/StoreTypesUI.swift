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

class StoreTypesUI {
    
    let types = StoreTypesAPI()    
    
    /// Get product types
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getProductTypesForGallery(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = TagViewModels()
        
        types.getTypes(first: 100, success: { types in
            
            let viewModels = types.map { type -> DSViewModel in
                ui.galleryTag(title: type.readableString(), object: type as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get product types
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getProductTypesForGrid(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = TagViewModels()
        
        types.getTypes(first: 100, success: { types in
            
            let viewModels = types.map { type -> DSViewModel in
                ui.gridTag(title: type.readableString(), object: type as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
}
