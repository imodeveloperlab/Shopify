//
//  StoreClient.swift
//  Shopify
//  DSKit docs https://dskit.app/components
//  Shopify docs https://github.com/Shopify/mobile-buy-sdk-ios
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

class GraphClient {
    
    let client: Graph.Client
    
    static let shared = GraphClient()
    
    init() {
        
        // Initializing a client to return translated content
        client = Graph.Client(
            shopDomain: shopDomain,
            apiKey:     shopApiKey
        )
        
        client.cachePolicy = .networkOnly
    }
}
