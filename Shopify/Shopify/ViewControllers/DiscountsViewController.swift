//
//  DiscountsViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class DiscountsViewController: DSViewController {
    
    // View models
    var discountsViewModels: [DSViewModel]?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("DISCOUNTS")
        updateDiscounts()
    }
    
    /// Update discounts
    func updateDiscounts() {
        
        let storeUI = StoreProductsUI()
        self.loading(true)
        storeUI.getDiscountProducts(count: 100, success: { viewModels in
            
            self.loading(false)
            self.discountsViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    func updateUI() {
        
        var sections = [DSSection]()
        
        // Discounts
        if var discountsViewModels = discountsViewModels {
            
            discountsViewModels = discountsViewModels.didTapObject({ (productId: String) in
                
                let vc = ProductDetailsViewController()
                vc.productId = productId
                self.push(vc)
                
            })
            
            let section = discountsViewModels.grid()
            sections.append(section)
        }
                
        self.show(content: sections)
    }
}
