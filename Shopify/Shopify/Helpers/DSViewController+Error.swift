//
//  DSViewController+Error.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 28.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit

extension DSViewController {
    
    func handleFail(stopLoading: Bool = false) -> Fail {
        
        let defaultMessage = "There seems to be a problem, please try again later"
        
        return { error in
            
            if stopLoading {
                self.loading(false)
            }
            
            switch error.code {
            case .UNKNOWN_ERROR:
                self.show(message: defaultMessage, type: .error)
            case .GraphQueryError(let error):
                self.show(message: error?.localizedDescription ?? defaultMessage , type: .error)
            case .StorefrontCheckoutUserError(let error):
                self.show(message: error?.message ?? defaultMessage , type: .error)
            }
        }
    }
}
