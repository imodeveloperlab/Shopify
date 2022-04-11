//
//  ProductFilter.swift
//  Shopify
//  DSKit docs https://dskit.app/components
//  Shopify docs https://github.com/Shopify/mobile-buy-sdk-ios
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

struct ProductFilter {
    
    internal init(collection: ProductCollection? = nil,
                  tag: ProductTag? = nil,
                  type: ProductType? = nil,
                  sort: SortOption? = nil,
                  search: ProductSearch? = nil) {
        
        self.collection = collection
        self.tag = tag
        self.type = type
        self.sort = sort
        self.search = search
    }
    
    var collection: ProductCollection? = nil
    var tag: ProductTag? = nil
    var type: ProductType? = nil
    var sort: SortOption? = nil
    var search: ProductSearch? = nil
}

extension ProductFilter {
    
    func noOptionsSelected() -> Bool {
        
        return collection == nil &&
            tag == nil &&
            type == nil &&
            sort == nil &&
            search == nil
    }
}

extension ProductFilter {
    
    func queryString() -> String? {
        
        var queryString: String?
        
        if let tag = self.tag {
            queryString = "tag:\(tag)"
        }
        
        // Alias
        if let search = self.search {
            if queryString != nil {
                queryString = "AND \(search)"
            } else {
                queryString = "\(search)"
            }
        }
        
        // Collection type
        if let type = self.type {
            if queryString != nil {
                queryString = "AND product_type:\(type)"
            } else {
                queryString = "product_type:\(type)"
            }
        }
        
        return queryString
    }
    
    func sortKey() -> Storefront.ProductSortKeys? {
        
        var sortKeyValue: Storefront.ProductSortKeys?
        
        if let sortKey = self.sort {
            sortKeyValue = Storefront.ProductSortKeys(rawValue: sortKey)
        }
        
        return sortKeyValue
    }
}
