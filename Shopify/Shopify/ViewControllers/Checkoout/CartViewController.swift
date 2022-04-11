//
//  CartViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import Buy

final class CartViewController: DSViewController {
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("CART")
        
        updateUI()
        
        let status = CartStatus()
        status.cartDidUpdate = { products in
            self.updateUI()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func updateUI() {
        if Cart.shared.productQuantity == 0 {
            showPlaceHolder()
            hideBottomContent()
        } else {
            update()
            updateTotalView()
        }
    }
    
    func showPlaceHolder() {
        
        self.showPlaceholder(image: UIImage(systemName: "cart"),
                             text: loc("CART_EMPTY"))
    }
    
    // Call every time some data have changed
    func update() {
        show(content: productsSection())
    }
    
    /// Update total view
    func updateTotalView() {
        
        guard Cart.shared.productQuantity != 0 else {
            hideBottomContent()
            return
        }
        
        let totalAmount: Decimal = Cart.shared.allProducts().reduce(0) { result, cartProduct in
            let result = result + ((cartProduct.product.variantBySelectedOptions?.priceV2.amount ?? 0) *  Decimal(cartProduct.quantity))
            return result
        }
        
        let currency = Cart.shared.allProducts().reduce("") { result, cartProduct in
            cartProduct.product.variantBySelectedOptions?.priceV2.currencyCode.rawValue
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        guard let amount = formatter.string(from: totalAmount as NSNumber) else {
            return
        }
        
        let price = DSPrice(amount: amount, currency: currency ?? "$")
        
        // Total label
        var totalText = DSLabelVM(.title2, text: loc("CART_TOTAL"))
        let forString = "\(loc("CART_FOR")) \(Cart.shared.productQuantity) \(Int(Cart.shared.productQuantity).getCorrectForm(singular: loc("CART_ITEM"), plural: loc("CART_ITEMS"))) "
        
        // Text
        let composer = DSTextComposer(alignment: .right)
        composer.add(type: .subheadline, text: forString)
        composer.add(price: price, size: .large, newLine: false)
        
        // Price
        let priceVM = composer.textViewModel()
        totalText.supplementaryItems = [priceVM.asSupplementary(position: .rightCenter, offset: .custom(.zero))]
        
        // Continue button
        var button = DSButtonVM(title: loc("CART_CHECKOUT_BUTTON"), icon: UIImage(systemName: "creditcard.fill"))
        button.didTap { [unowned self] (button: DSButtonVM) in
            
            let vc = CheckoutViewController()
            vc.hidesBottomBarWhenPushed = true
            self.push(vc)
        }
        
        showBottom(content: [totalText, button].list())
    }
}

// MARK: - Products

extension CartViewController {
    
    /// Products gallery
    /// - Returns: DSSection
    func productsSection() -> DSSection {
        
        let models: [DSViewModel] = Cart.shared.allProducts().map { cartProduct -> DSViewModel in
            return self.product(cartProduct: cartProduct)
        }
        
        return models.list()
    }
    
    /// Product
    /// - Parameters:
    ///   - title: String
    ///   - description: String
    ///   - image: URL?
    ///   - badge: String?
    /// - Returns: DSViewModel
    func product(cartProduct: CartProduct) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer(alignment: .left)
        composer.add(type: .headlineWithSize(16), text: cartProduct.product.title.readableString(), spacing: 5)
        
        // Description
        if let description = cartProduct.product.variantBySelectedOptions?.title {
            composer.add(type: .headlineWithSize(11), text: "\(loc("CART_PRODUCT_VARIANT")) ", spacing: 5)
            composer.add(type: .subheadlineWithSize(11), text: description, newLine: false)
            
            composer.add(type: .headlineWithSize(11), text: " \(loc("CART_PRODUCT_QUANTITY")) ", newLine: false)
            composer.add(type: .subheadlineWithSize(11), text: "\(cartProduct.quantity)", newLine: false)
        }
        
        // Price
        if let price = cartProduct.product.variantBySelectedOptions?.price() {
            composer.add(price: price, spacing: 5)
        }
        
        // Action
        var action = composer.actionViewModel()
        action.leftImage(url: cartProduct.product.coverImage(), size: .size(.init(width: 100, height: 70)))
        action.leftViewPosition = .top
        
        action.rightButton(sfSymbolName: "minus.circle.fill",
                           style: .custom(size: 18, weight: .regular)) { [unowned self] in
            
            Cart.shared.removeProduct(product: cartProduct)
            self.updateUI()
        }
        
        // Handle did tap
        action.didTap { [unowned self] (_ :DSCardVM) in
            self.dismiss()
        }
        
        return action
    }
    
    /// Label supplementary view
    /// - Parameter title: String
    /// - Returns: DSSupplementaryView
    func label(title: String) -> DSSupplementaryView {
        
        let label = DSLabelVM(.headlineWithSize(10), text: title)
        
        let offset = appearance.groupMargins + 4
        
        let supView = DSSupplementaryView(view: label,
                                          position: .leftBottom,
                                          background: .primary,
                                          insets: .small,
                                          offset: .custom(.init(x: offset, y: offset)),
                                          cornerRadius: .custom(5))
        
        return supView
    }
}
