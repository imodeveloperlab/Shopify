//
//  User.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 20.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

final class User {
    
    private let userAddressesKey = "userAddressesKey1"
    private let userInfoKey = "userInfoKey1"
    
    var address: UserAddress
    var userPhoneNumberOrEmail: String? = nil

    static let shared = User()
    
    init() {
        
        // Load address
        if let result = try? UserDefaults.standard.getObject(forKey: userAddressesKey, castTo: UserAddress.self) {
            self.address = result
        } else {
            self.address = UserAddress()
        }
        
        // Load user info
        userPhoneNumberOrEmail = UserDefaults.standard.value(forKey: userInfoKey) as? String
    }
    
    /// Save data
    func saveData() {
        
        do {
            try UserDefaults.standard.setObject(self.address, forKey: userAddressesKey)
        } catch {
            print(error)
        }
        
        UserDefaults.standard.setValue(userPhoneNumberOrEmail, forKey: userInfoKey)
        UserDefaults.standard.synchronize()
    }
}
