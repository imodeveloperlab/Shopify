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

class StoreCheckoutAPI {
    
    let client: Graph.Client
    
    init() {
        client = GraphClient.shared.client
        client.cachePolicy = .cacheFirst(expireIn: 60)
    }
    
    /// Get products
    /// - Parameters:
    ///   - tag: Product tag
    ///   - first: Count
    ///   - success: Success<[Storefront.Product]>
    ///   - fail: Fail
    func prepareForCheckout(products: [CartProduct],
                            success: @escaping Success<Storefront.Checkout>,
                            fail: @escaping Fail) {
        
        let items: [Storefront.CheckoutLineItemInput] = products.compactMap { cartProduct in
            
            guard let id = cartProduct.product.variantBySelectedOptions?.id else {
                return nil
            }
            
            return Storefront.CheckoutLineItemInput.create(quantity: cartProduct.quantity, variantId: id)
        }
        
        let input = Storefront.CheckoutCreateInput.create(
            lineItems: .value(items)
        )
        
        let mutation = Storefront.buildMutation { $0
            .checkoutCreate(input: input) { $0
                .checkout { $0
                    .id()
                    .webUrl()
                }
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { result, error in
            
            guard error == nil else {
                fail(.init(code: .GraphQueryError(error), errorDescription: error.debugDescription))
                return
            }
            
            guard let userError = result?.checkoutCreate?.checkoutUserErrors else {
                return
            }
            
            if !userError.isEmpty {
                
                for error in userError {
                    print(error.debugDescription)
                }
                
                fail(.init(code: .StorefrontCheckoutUserError(userError.first), errorDescription: error.debugDescription))
            }
            
            guard let checkout = result?.checkoutCreate?.checkout else {
                return
            }
            
            success(checkout)
        }
        
        task.resume()
    }
    
    /// Update contact information
    /// - Parameters:
    ///   - tag: Product tag
    ///   - first: Count
    ///   - success: Success<[Storefront.Product]>
    ///   - fail: Fail
    func updateEmail(email: String,
                     checkout: Storefront.Checkout,
                     success: @escaping Success<Void>,
                     fail: @escaping Fail) {
        
        let mutation = Storefront.buildMutation { $0
            .checkoutEmailUpdateV2(checkoutId: checkout.id, email: email) { $0
                .checkout { $0
                    .id()
                }
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { result, error in
            
            guard error == nil else {
                fail(.init(code: .GraphQueryError(error), errorDescription: error.debugDescription))
                return
            }
            
            guard let userError = result?.checkoutEmailUpdateV2?.checkoutUserErrors else {
                return
            }
            
            if !userError.isEmpty {
                
                for error in userError {
                    print(error.debugDescription)
                }
                
                fail(.init(code: .StorefrontCheckoutUserError(userError.first), errorDescription: error.debugDescription))
            }
            
            success(())
        }
        
        task.resume()
    }
    
    /// Update shipping address
    /// - Parameters:
    ///   - tag: Product tag
    ///   - first: Count
    ///   - success: Success
    ///   - fail: Fail
    func updateShippingAddress(address: UserAddress,
                               checkout: Storefront.Checkout,
                               success: @escaping Success<Void>,
                               fail: @escaping Fail) {
        
        let mutation = Storefront.buildMutation { $0
            .checkoutShippingAddressUpdateV2(shippingAddress: address.shippingAddress(), checkoutId: checkout.id) { $0
                .checkout { $0
                    .id()
                }
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { result, error in
            
            guard error == nil else {
                fail(.init(code: .GraphQueryError(error), errorDescription: error.debugDescription))
                return
            }
            
            guard let userError = result?.checkoutShippingAddressUpdateV2?.checkoutUserErrors else {
                return
            }
            
            if !userError.isEmpty {
                fail(.init(code: .StorefrontCheckoutUserError(userError.first), errorDescription: error.debugDescription))
                return
            }
            
            success(())
        }
        
        task.resume()
    }
    
    /// Get shipping rates
    /// - Parameters:
    ///   - tag: Product tag
    ///   - first: Count
    ///   - success: Success
    ///   - fail: Fail
    func getShippingRates(checkout: Storefront.Checkout,
                          success: @escaping Success<[Buy.Storefront.ShippingRate]>,
                          fail: @escaping Fail) {
        
        let query = Storefront.buildQuery { $0
            .node(id: checkout.id) { $0
                .onCheckout { $0
                    .id()
                    .availableShippingRates { $0
                        .ready()
                        .shippingRates { $0
                            .handle()
                            .priceV2({ $0
                                .amount()
                                .currencyCode()
                            })
                            .title()
                        }
                    }
                }
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            
            guard let checkout = response?.node as? Storefront.Checkout else {
                fail(.init(code: .UNKNOWN_ERROR))
                return
            }
            
            guard let shippingRates = checkout.availableShippingRates?.shippingRates else {
                fail(.init(code: .UNKNOWN_ERROR))
                return
            }
            
            success(shippingRates)
            
        }
        task.resume()
    }
    
    /// Update shipping address
    /// - Parameters:
    ///   - tag: Product tag
    ///   - first: Count
    ///   - success: Success
    ///   - fail: Fail
    func updateShippingRate(shippingRate: Buy.Storefront.ShippingRate,
                            checkout: Storefront.Checkout,
                            success: @escaping Success<Void>,
                            fail: @escaping Fail) {
        
        let mutation = Storefront.buildMutation { $0
            .checkoutShippingLineUpdate(checkoutId: checkout.id, shippingRateHandle: shippingRate.handle) { $0
                .checkout { $0
                    .id()
                }
                .checkoutUserErrors { $0
                    .field()
                    .message()
                }
            }
        }
        
        let task = client.mutateGraphWith(mutation) { result, error in
            
            guard error == nil else {
                fail(.init(code: .GraphQueryError(error), errorDescription: error.debugDescription))
                return
            }
            
            guard let userError = result?.checkoutShippingLineUpdate?.checkoutUserErrors else {
                return
            }
            
            if !userError.isEmpty {
                
                for error in userError {
                    print(error.debugDescription)
                }
                
                fail(.init(code: .StorefrontCheckoutUserError(userError.first), errorDescription: error.debugDescription))
            }
            
            success(())
        }
        
        task.resume()
    }
    
    /// Checkout state
    /// - Parameters:
    ///   - checkoutId: GraphQL.ID
    ///   - success: Success<Buy.GraphQL.ID>
    ///   - fail: Fail
    func checkoutState(checkout: Storefront.Checkout,
                       success: @escaping Success<Storefront.Order>,
                       fail: @escaping Fail) -> Task {
        
        let retry = Graph.RetryHandler<Storefront.QueryRoot>(endurance: .infinite) { (response, error) -> Bool in            
            return (response?.node as? Storefront.Checkout)?.order == nil
        }

        let query = Storefront.buildQuery { $0
            .node(id: checkout.id) { $0
                .onCheckout { $0
                    .order { $0
                        .id()
                        .name()
                        .orderNumber()
                        .totalPriceV2({ $0
                            .amount()
                            .currencyCode()
                        })
                    }
                }
            }
        }

        let task = self.client.queryGraphWith(query, retryHandler: retry) { response, error in
            
            if let error = error {
                fail(.init(code: .GraphQueryError(error)))
                return
            }
            
            let checkout = (response?.node as? Storefront.Checkout)
            
            guard let order = checkout?.order else {
                fail(.init(code: .UNKNOWN_ERROR))
                return
            }
            
            success(order)
        }

        task.resume()
        
        return task
    }
}
