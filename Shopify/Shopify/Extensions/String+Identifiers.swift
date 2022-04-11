//
//  String+Identifiers.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

extension String {
    
    func readableString() -> String {
        var text = self
        text = text.replacingOccurrences(of: "_", with: " ")
        text = text.lowercased()
        text = text.capitalized
        return text
    }
}
