//
//  UserAddress.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 20.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

struct UserAddress: Codable {
    
    var firstNameValue: String? = nil
    var lastNameValue: String? = nil
    var addressValue: String? = nil
    var apartamentSuiteValue: String? = nil
    var cityValue: String? = nil
    var countryNameValue: String? = nil
    var postalCodeValue: String? = nil
    
}

extension UserAddress {
    
    func fullAddress() -> String {
        
        var address = ""
        
        if let value = addressValue {
            address += " \(value)"
        }
        
        if let value = apartamentSuiteValue {
            address += " \(value)"
        }
        
        if let value = cityValue {
            address += " \(value)"
        }
        
        if let value = countryNameValue {
            address += " \(value)"
        }
        
        return address
        
    }
    
}

extension UserAddress {
    
    func shippingAddress() -> Storefront.MailingAddressInput {
        
        Storefront.MailingAddressInput.create(address1: .value(addressValue),
                                              address2: .undefined,
                                              city: .value(cityValue),
                                              company: .undefined,
                                              country: .value(countryNameValue),
                                              firstName: .value(firstNameValue),
                                              lastName: .value(lastNameValue),
                                              phone: .undefined,
                                              province: .undefined,
                                              zip: .value(postalCodeValue))
    }
}
