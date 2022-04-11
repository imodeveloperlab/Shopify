//
//  Storefront.Product+Images.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 27.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import DSKit

extension Storefront.Product {
    
    func coverImage() -> URL? {
        return self.images.edges.first?.node.transformedSrc
    }
}

