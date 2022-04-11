//
//  ViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class ViewController: DSTabBarViewController {
    
    let home = HomeViewController()
    let search = SearchViewController()
    let cart = CartViewController()
    let catalog = CatalogViewController()
    let info = InfoViewController()
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let config = DSSFSymbolConfig.symbolConfig(style: .custom(size: 17, weight: .medium))
        let configSelected = DSSFSymbolConfig.symbolConfig(style: .custom(size: 20, weight: .semibold))
        
        home.tabBarItem.title = loc("HOME")
        home.tabBarItem.image = UIImage(systemName: "bag", withConfiguration: config)
        home.tabBarItem.selectedImage = UIImage(systemName: "bag.fill", withConfiguration: configSelected)
        
        search.tabBarItem.title = loc("SEARCH")
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        search.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass", withConfiguration: configSelected)
        
        cart.tabBarItem.title = loc("CART")
        cart.tabBarItem.image = UIImage(systemName: "cart", withConfiguration: config)
        cart.tabBarItem.selectedImage = UIImage(systemName: "cart.fill", withConfiguration: configSelected)
        
        let status = CartStatus()
        status.cartDidUpdate = { products in
            
            if Cart.shared.productQuantity > 0 {
                self.cart.tabBarItem.badgeValue = "\(Cart.shared.productQuantity)"
            } else {
                self.cart.tabBarItem.badgeValue = nil
            }
            
            self.cart.tabBarItem.badgeColor = UIColor.red
        }
        
        catalog.tabBarItem.title = loc("CATALOG")
        catalog.tabBarItem.image = UIImage(systemName: "character.book.closed", withConfiguration: config)
        catalog.tabBarItem.selectedImage = UIImage(systemName: "character.book.closed.fill", withConfiguration: configSelected)
        
        info.tabBarItem.title = loc("INFO")
        info.tabBarItem.image = UIImage(systemName: "info.circle", withConfiguration: config)
        info.tabBarItem.selectedImage = UIImage(systemName: "info.circle.fill", withConfiguration: configSelected)
        
        setViewControllers([DSNavigationViewController(rootViewController: home),
                            DSNavigationViewController(rootViewController: catalog),
                            DSNavigationViewController(rootViewController: search),
                            DSNavigationViewController(rootViewController: cart),
                            DSNavigationViewController(rootViewController: info),], animated: true)
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct ViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            PreviewContainer(VC: ViewController(), nil).edgesIgnoringSafeArea(.all)
        }
    }
}
