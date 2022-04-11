//
//  DSViewController+FilterOption.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 29.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit

extension DSViewController {
    
    func option(title: String,
                identifier: String,
                currentSelected: String?,
                didSelect: @escaping Done<String>) -> DSViewModel {
        
        let isSelected = identifier == currentSelected
        
        // Text
        let composer = DSTextComposer()
        composer.add(type: isSelected ? .headlineWithSize(15) : .subheadline, text: title)
        var model = composer.checkboxActionViewModel(selected: isSelected)
        
        // Handle action
        model.didTap { (_: DSActionVM) in
            didSelect(identifier)
        }
        
        return model
    }
}
