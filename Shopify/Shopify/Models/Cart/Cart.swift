//
//  Cart.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 18.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import Combine

class Cart {
    
    private var products = [CartProduct]()
    
    var productQuantity: Int32 {
        return products.reduce(into: 0) { result, cartProduct in
            result += cartProduct.quantity
        }
    }
    
    static let shared = Cart()
    internal var dataPublisher = PassthroughSubject<[CartProduct], Never>()
    
    /// Add product
    /// - Parameter product: Storefront.Product
    func addProduct(product: CartProduct) {
        products.append(product)
        dataPublisher.send(products)
    }
    
    /// Get all products
    /// - Returns: [Storefront.Product]
    func allProducts() -> [CartProduct] {
        return products
    }
    
    /// Remove product
    /// - Parameter product: Storefront.Product
    func removeProduct(product: CartProduct) {
        
        products.removeAll { inProduct in
             return inProduct.id == product.id
        }
        
        dataPublisher.send(products)
    }
    
    /// Check if shipping is required for this cart
    /// - Returns: Bool
    func isShippingRequired() -> Bool {
        
        let shipping = products.filter { cartProduct in
            return (cartProduct.product.variantBySelectedOptions?.requiresShipping ?? false) == true
        }
        
        return shipping.count > 0
    }
    
    /// Clear Cart
    func clearCart() {
        products.removeAll()
        dataPublisher.send(products)
    }
    
    init() {
        
    }
}

