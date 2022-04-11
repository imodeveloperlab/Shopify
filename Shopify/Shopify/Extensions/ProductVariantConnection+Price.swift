//
//  ProductVariantConnection+Price.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 27.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import DSKit

extension Storefront.ProductVariantConnection {
    
    func firstPrice() -> DSPrice? {
        
        if let first = self.edges.first {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            if let amount = formatter.string(from: first.node.priceV2.amount as NSNumber) {
                return DSPrice(amount: amount, currency: first.node.priceV2.currencyCode.rawValue)
            }
        }
        
        return nil
    }    
}
