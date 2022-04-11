//
//  Store.swift
//  Shopify
//  DSKit docs https://dskit.app/components
//  Shopify docs https://github.com/Shopify/mobile-buy-sdk-ios
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

class StoreInfoAPI {
    
    let client: Graph.Client
    
    init() {
        client = GraphClient.shared.client
        client.cachePolicy = .cacheFirst(expireIn: 60)
    }
    
    /// Get store name
    /// - Parameters:
    ///   - success: Success<String>
    ///   - fail: Fail
    func getStoreName(success: @escaping Success<String>, fail: @escaping Fail) {
        
        let query = Storefront.buildQuery { $0
            .shop { $0
                .name()
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            if let response = response {
                success(response.shop.name)
            } else {
                
                print(error.debugDescription)
                fail(ShopError(code: .GraphQueryError(error)))
            }
        }
        task.resume()
    }
}
