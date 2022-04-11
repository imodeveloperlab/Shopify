//
//  CardCollection.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 27.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit
import UIKit

class CollectionViewModels {
    
    func card(title: String, description: String, image: URL?, object: AnyObject?) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(14), text: title)
        composer.add(type: .subheadlineWithSize(12), text: description.maxLength(length: 40))
        
        var action = composer.actionViewModel()
        action.topImage(url: image, height: .unknown, contentMode: .scaleAspectFill)
        action.height = .absolute(220)
        action.object = object
        
        return action
    }
    
    func list(title: String, description: String, image: URL?, object: AnyObject?) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(15), text: title.lowercased().capitalized)
        composer.add(type: .subheadline, text: description)
        
        var category = DSActionVM(composer: composer)
        category.object = object
        category.rightArrow()
        
        if let image = image {
            category.leftImage(url: image, style: .themeCornerRadius, size: .size(CGSize(width: 60, height: 60)), contentMode: .scaleAspectFill)
        }
        
        return category
    }
}
