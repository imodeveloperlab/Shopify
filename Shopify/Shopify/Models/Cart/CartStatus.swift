//
//  Cart.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 18.05.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy
import Combine
import DSKit
import UIKit
import DSKitFakery

class CartStatus: Subscriber {
    
    public var cartDidUpdate: (([CartProduct]) -> Void)?
    
    var products = [CartProduct]()
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: [CartProduct]) -> Subscribers.Demand {
        cartDidUpdate?(input)
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Received completion: \(completion)")
    }
    
    init() {
        Cart.shared.dataPublisher.subscribe(self)
    }
    
    deinit {
        print("Deinit")
    }
}

extension DSViewController {
    
    @objc func openCart() {
        self.push(CartViewController())
    }
    
    /// Show cart
    func showCartInNavigationBar() {
        
        let cartStatus = CartStatus()
        
        updateCartButton(productsCount: Int(Cart.shared.productQuantity), cartButton: cartButton(target: self, action: #selector(self.openCart)))
        cartStatus.cartDidUpdate = { products in
            self.updateCartButton(productsCount: products.count, cartButton: self.cartButton(target: self, action: #selector(self.openCart)))
        }
    }
    
    func cartButton(target: AnyObject?, action: Selector?) -> UIBarButtonItem  {
        
        let cartButton = UIBarButtonItem(icon: UIImage(systemName: "cart.fill"),
                                         badge: "\(Cart.shared.productQuantity)",
                                         target: target,
                                         action: action)
        
        cartButton.tag = 99999
        return cartButton
    }
    
    /// Update cart button
    /// - Parameters:
    ///   - productsCount: Int
    ///   - cartButton: UIBarButtonItem
    fileprivate func updateCartButton(productsCount: Int,
                                      cartButton: UIBarButtonItem) {
        
        var items = self.navigationItem.rightBarButtonItems
        
        if items == nil {
            items = [UIBarButtonItem]()
        }
        
        guard var items = items else {
            return
        }
        
        items.removeAll { item in
            item.tag == 99999
        }
        
        if productsCount > 0 {
            items.insert(cartButton, at: 0)
        } else {
            items.removeAll { item in
                item == cartButton
            }
        }
        
        self.navigationItem.setRightBarButtonItems(items, animated: true)
    }
}

extension UIBarButtonItem {
        
    convenience init(icon: UIImage?, badge: String, target: AnyObject?, action: Selector?) {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.image = icon
        imageView.tintColor = DSAppearance.shared.main.navigationBar.buttons

        let label = UILabel(frame: CGRect(x: 12, y: -5, width: 18, height: 18))
        label.text = badge
        label.backgroundColor = DSAppearance.shared.main.tabBar.badge
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.clipsToBounds = true
        label.layer.cornerRadius = 18 / 2
        label.textColor = .white
        label.bounce()

        let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        buttonView.addSubview(imageView)
        buttonView.addSubview(label)
        buttonView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
        
        self.init(customView: buttonView)
    }
}
