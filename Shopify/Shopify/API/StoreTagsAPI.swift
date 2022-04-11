//
//  StoreTypes.swift
//  Shopify
//  DSKit docs https://dskit.app/components
//  Shopify docs https://github.com/Shopify/mobile-buy-sdk-ios
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

class StoreTagsAPI {
    
    let client: Graph.Client
    
    init() {
        client = GraphClient.shared.client
        client.cachePolicy = .cacheFirst(expireIn: 60)
    }
    
    /// Get tags
    /// - Parameters:
    ///   - first: Count
    ///   - success: Success<[Storefront.Collection]>
    ///   - fail: Fail
    func getTags(first: Int32, success: @escaping Success<[String]>, fail: @escaping Fail) {
        
        let query = Storefront.buildQuery { $0
            .productTags(first: first) { $0
                .edges { $0
                    .node()
                }
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            
            if let types = response?.productTags.edges.map({ $0.node }) {
                success(types)
            } else {
                fail(.init(code: .UNKNOWN_ERROR))
            }
            
        }
        task.resume()
    }
}
