//
//  ShopErrorCode.swift
//  HueSDK
//
//  Created by Borinschi Ivan on 1/12/20.
//  Copyright © 2020 Imodeveloperlab. All rights reserved.
//

import Foundation
import Buy

public struct ShopError: Error {
    
    public var code: ShopErrorCode = .UNKNOWN_ERROR
    public var errorDescription: String?
    
    public init(code: ShopErrorCode = .UNKNOWN_ERROR, errorDescription: String? = nil) {
        self.code = code
        self.errorDescription = errorDescription
    }
}

public enum ShopErrorCode {
    case UNKNOWN_ERROR
    case GraphQueryError(Graph.QueryError?)
    case StorefrontCheckoutUserError(Storefront.CheckoutUserError?)
}
