//
//  DSViewController+UI.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit

extension DSViewController {
    
    /// Header view model
    /// - Parameter title: String
    /// - Returns: DSViewModel
    func header(title: String, handle: @escaping HandleDidTap) -> DSViewModel {
        
        let composer = DSTextComposer()
        composer.add(type: .headline, text: title)
        var header = composer.actionViewModel()
        header.style.displayStyle = .default

        header.rightButton(title: loc("VIEW_ALL_CALL_TO_ACTION"), sfSymbolName: "chevron.right", style: .medium) {
            handle()
        }
        
        return header
    }
}
