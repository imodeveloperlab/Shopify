//
//  String+MaxLength.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

extension String {
    
    func maxLength(length: Int) -> String {
        
        var text = self
        
        if text.count > length {
            
            if text.hasSuffix(" ") {
                text.removeLast()
            }
            
            text = String("\(text.prefix(length))...")
        }
        
        return text
    }
    
}
