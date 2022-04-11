//
//  ProductViewModels.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 27.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit

class ProductViewModels {
    
    /// Top Product
    /// - Parameters:
    ///   - title: String
    ///   - image: URL?
    ///   - price: DSPrice?
    /// - Returns: DSViewModel
    func topProduct(title: String,
                    image: URL?,
                    price: DSPrice?,
                    object: AnyObject?) -> DSViewModel {
        
        var imageViewModel = DSImageVM(imageUrl: image , height: .absolute(200))
        imageViewModel.object = object
        
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .text(font: .headlineWithSize(14), color: .white), text: title)
        
        if let price = price {
            let color = DSDesignablePriceColor(currency: .white, amount: .white, regularAmount: .white)
            composer.add(price: price, size: .medium, color: .custom(color))
        }
        
        let label = composer.textViewModel().asSupplementary(position: .leftTop,
                                                             background: .clear,
                                                             insets: .small,
                                                             cornerRadius: .custom(5))
        imageViewModel.supplementaryItems = [label]
        
        return imageViewModel
    }
    
    /// Product
    /// - Parameters:
    ///   - title: String
    ///   - description: String
    ///   - imageUrl: URL?
    ///   - price: DSPrice
    /// - Returns: DSViewModel
    func product(title: String,
                 description: String,
                 image: URL?,
                 price: DSPrice?,
                 object: AnyObject?) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(12), text: title.lowercased().capitalized)
        
        if let price = price {
            composer.add(price: price)
        }
        
        // Action
        var action = composer.actionViewModel()
        action.topImage(url: image, height: .unknown, contentMode: .scaleAspectFill)
        action.height = .absolute(200)
        action.object = object
        
        return action
    }
    
    /// Product
    /// - Parameters:
    ///   - title: String
    ///   - description: String
    ///   - imageUrl: URL?
    ///   - price: DSPrice
    /// - Returns: DSViewModel
    func bigProduct(title: String,
                    description: String,
                    image: URL?,
                    price: DSPrice?,
                    object: AnyObject?) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(14), text: title.readableString())
        composer.add(type: .subheadline, text: description)
        
        if let price = price {
            composer.add(price: price)
        }
        
        // Action
        var action = composer.actionViewModel()
        action.topImage(url: image, height: .unknown, contentMode: .scaleAspectFill)
        action.height = .absolute(300)
        action.object = object
        
        return action
    }
    
    /// Product
    /// - Parameters:
    ///   - title: String
    ///   - description: String
    ///   - imageUrl: URL?
    ///   - price: DSPrice
    /// - Returns: DSViewModel
    func compactProduct(title: String, description: String, image: URL?, price: DSPrice?) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(13), text: title.lowercased().capitalized)
        composer.add(type: .subheadlineWithSize(11), text: description.maxLength(length: 50))
        
        if let price = price {
            composer.add(price: price)
        }
        
        // Action
        var action = composer.actionViewModel()
        action.leftImage(url: image, size: .size(.init(width: 100, height: 80)))
        
        return action
    }
}
