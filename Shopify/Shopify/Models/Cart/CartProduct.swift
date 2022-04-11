//
//  CartProduct.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 21.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

struct CartProduct {
    var quantity: Int32
    var product: Storefront.Product
    var id: UUID
}
