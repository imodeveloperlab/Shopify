//
//  StoreProductsUI.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import DSKit

class StoreProductsUI {
    
    let products = StoreProductsAPI()
    
    /// Get top products gallery
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getTopProductsGallery(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let filter = ProductFilter(tag: topProductsTagName)
        
        products.getProducts(count: 100, filter: filter, success: { products in
            
            let viewModels = products.map { product -> DSViewModel in
                return DSImageVM(imageUrl: product.images.edges.first?.node.transformedSrc , height: .absolute(200))
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get top products gallery
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getTopProductsWithTitleAndPriceGallery(success: @escaping Success<[DSViewModel]>,
                                                fail: @escaping Fail) {
        
        let ui = ProductViewModels()
        
        let filter = ProductFilter(tag: topProductsTagName)
        
        products.getProducts(count: 100, filter: filter, success: { products in
            
            let viewModels = products.map { product -> DSViewModel in
                
                return ui.topProduct(title: product.title,
                                     image: product.coverImage(),
                                     price: product.firstPrice(),
                                     object: product.id.rawValue as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get discount products
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getDiscountProducts(count: Int32, success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let filter = ProductFilter(tag: discountProductsTagName)
        
        products.getProducts(count: count, filter: filter, success: { products in
            
            let ui = ProductViewModels()
            
            let viewModels = products.map { (product) -> DSViewModel in
                
                return ui.product(title: product.title,
                                  description: product.description,
                                  image: product.coverImage(),
                                  price: product.firstPrice(),
                                  object: product.id.rawValue as AnyObject)
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get products gallery
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getProducts(filter: ProductFilter? = nil,
                     success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let ui = ProductViewModels()
        
        products.getProducts(count: 100,
                             filter: filter,
                             success: { products in
                                
                                let viewModels = products.map { product -> DSViewModel in
                                    
                                    return ui.product(title: product.title,
                                                      description: product.description,
                                                      image: product.coverImage(),
                                                      price: product.firstPrice(),
                                                      object: product.id.rawValue as AnyObject)
                                }
                                
                                success(viewModels)
                                
                             }, fail: fail)
    }
    
    /// Sort options
    /// - Parameters:
    ///   - first: Count
    ///   - success: Success<[Storefront.Collection]>
    ///   - fail: Fail
    func getProductSortOptions(success: @escaping Success<[DSViewModel]>, fail: @escaping Fail) {
        
        let store = StoreProductsAPI()
        
        store.getProductSortKeys(success: { keys in
            
            let viewModels = keys.map { key -> DSViewModel in
                
                let composer = DSTextComposer()
                composer.add(type: .headlineWithSize(15), text: key.rawValue.readableString())
                var action = composer.actionViewModel()
                action.object = key.rawValue as AnyObject
                return action
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
    
    /// Get search products
    /// - Parameters:
    ///   - success: Success<[DSViewModel]>
    ///   - fail: Fail
    func getSearchProducts(search: String? = nil,
                           success: @escaping Success<[DSViewModel]>,
                           fail: @escaping Fail) {
        
        let ui = ProductViewModels()
        
        let filter = ProductFilter(search: search)
        
        products.getProducts(count: 100, filter: filter, success: { products in
            
            let viewModels = products.map { product -> DSViewModel in
                
                return ui.compactProduct(title: product.title,
                                         description: product.description,
                                         image: product.coverImage(),
                                         price: product.firstPrice())
            }
            
            success(viewModels)
            
        }, fail: fail)
    }
}
