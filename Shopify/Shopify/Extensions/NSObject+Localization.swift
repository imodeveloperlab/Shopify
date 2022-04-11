//
//  UIViewController+Localization.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 21.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

extension NSObject {
    func loc(_ key: String) -> String {
        NSLocalizedString(key, comment: key)
    }
}
