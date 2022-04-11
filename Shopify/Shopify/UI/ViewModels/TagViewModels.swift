//
//  TagViewModels.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit

class TagViewModels {
    
    func galleryTag(title: String, object: AnyObject? = nil) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .text(font: .headlineWithSize(12), color: .headline), text: title)
        var action = composer.actionViewModel()
        action.width = .estimated(100)
        action.height = .absolute(35)
        action.object = object
        action.rightNone()
        return action
    }
    
    func gridTag(title: String, object: AnyObject? = nil) -> DSViewModel {
        
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(14), text: title)
        var action = composer.actionViewModel()
        action.object = object
        action.rightNone()
        return action
    }
}
