//
//  ShippingViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import Buy
import SafariServices

final class ShippingViewController: DSViewController {
    
    var checkout: Storefront.Checkout
    var selectedMethod: String?
    var shippingRates = [Storefront.ShippingRate]()
    var checkoutTask: Task?
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("SHIPPING")
        self.update()
        
        let storeCheckoutAPI = StoreCheckoutAPI()
        
        self.loading(true)
        storeCheckoutAPI.getShippingRates(checkout: checkout, success: { rates in
            
            self.selectedMethod = rates.first?.title
            self.shippingRates = rates
            self.loading(false)
            self.update()
            
        }, fail: { error in
            
            self.webCheckout()
            
        })
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.after(2) {
            self.checkoutTask?.cancel()
            self.loading(false)
        }
    }
    
    func update() {
        self.show(content: [contactSection(), shippingSection()])
        self.showBottom(content: bottomContentSection())
    }
    
    init(checkout: Storefront.Checkout) {
        self.checkout = checkout
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Next Step

extension ShippingViewController {
    
    /// Bottom content section
    /// - Returns: DSSection
    func bottomContentSection() -> DSSection {
        
        let icon = DSSFSymbolConfig.buttonIcon("arrow.right")
        var button = DSButtonVM(title: loc("SHIPPING_CONTINUE_TO_PAYMENT"), icon: icon) { [unowned self] _ in
            
            let storeCheckoutAPI = StoreCheckoutAPI()
            
            let shippingRates = shippingRates.filter { rate in
                rate.title == selectedMethod
            }
            
            guard let shippingRate = shippingRates.first else {
                return
            }
            
            self.loading(true)
            storeCheckoutAPI.updateShippingRate(shippingRate: shippingRate, checkout: checkout, success: {
             
                self.webCheckout()
                
            }, fail: { error in
                
                self.webCheckout()
                
            })
        }
        
        button.textAlignment = .left
        button.imagePosition = .rightMargin
        
        let section = button.list().subheadlineHeader(loc("SHIPPING_NEXT_STEP_PAYMENT"))
        return section
    }
    
    func webCheckout() {
                
        let storeCheckoutAPI = StoreCheckoutAPI()
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        
        let webViewController = SFSafariViewController(url: checkout.webUrl, configuration: config)
        self.present(webViewController, animated: true)
        
        self.checkoutTask = storeCheckoutAPI.checkoutState(checkout: checkout, success: { order in
            
            self.popToRoot()
            self.loading(false)
            Cart.shared.clearCart()
            
        }, fail: handleFail(stopLoading: true))
    }
}

extension ShippingViewController {
    
    func contactSection() -> DSSection {
        
        var contact = DSActionVM(title: loc("SHIPPING_CONTACT_HEADER"), subtitle: User.shared.userPhoneNumberOrEmail) { action in
            self.pop()
        }
        
        contact.rightButton(title: loc("SHIPPING_CHANGE_BUTTON"), style: .small) {
            self.pop()
        }
        
        var address = DSActionVM(title: loc("SHIPPING_SHIP_TO_HEADER"), subtitle: User.shared.address.fullAddress()) { action in
            self.pop()
        }
        
        address.rightButton(title: loc("SHIPPING_CHANGE_BUTTON"), style: .small) {
            self.pop()
        }
        
        return [contact, address].list()
    }
}

extension ShippingViewController {
    
    /// Shipping
    /// - Returns: DSSection
    func shippingSection() -> DSSection {
        
        let viewModels = shippingRates.map { rate in
            
            shipping(title: rate.title,
                     price: rate.priceV2.price())
        }
        
        return viewModels.list().subheadlineHeader(loc("SHIPPING_SELECT_SHIPPING_METHOD_HEADER"))
    }
    
    /// Shipping method
    /// - Parameters:
    ///   - holder: String
    ///   - type: String
    ///   - expire: String
    ///   - end: String
    /// - Returns: DSViewModel
    func shipping(title: String,
                  price: DSPrice?) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer()
        composer.add(type: .headline, text: title, spacing: 5)
        
        if let price = price {
            composer.add(price: price, size: .medium)
        } else {
            composer.add(type: .headline, text: loc("SHIPPING_FREE"))
        }
        
        // Is selected
        let isSelected = title == selectedMethod
        
        // Action
        var action = composer.checkboxActionViewModel(selected: isSelected)
        
        // Handle did tap
        action.didTap { [unowned self] (_: DSActionVM) in
            self.selectedMethod = title
            self.update()
        }
        
        return action
    }
}
