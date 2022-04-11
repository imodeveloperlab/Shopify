//
//  MoneyV2+DSPrice.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 20.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import DSKit

extension Storefront.MoneyV2 {
    
    func price() -> DSPrice? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let amount = formatter.string(from: amount as NSNumber) {
            return DSPrice(amount: amount, currency: currencyCode.rawValue)
        }
        
        return nil
    }
}
