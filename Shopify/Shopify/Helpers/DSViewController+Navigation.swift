//
//  DSViewController+Navigation.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 29.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import DSKit

// MARK: - Actions
extension DSViewController {
    
    /// Open product details
    /// - Parameter productId: ProductID
    func openProductDetails(productId: ProductID) {
        
        let vc = ProductDetailsViewController()
        vc.productId = productId
        vc.hidesBottomBarWhenPushed = true
        self.push(vc)
    }
    
    /// Open catalog
    /// - Parameter filter: ProductFilter
    func openCatalog(filter: ProductFilter) {
        
        let vc = CatalogViewController()
        vc.filter = filter
        vc.hidesBottomBarWhenPushed = true
        self.push(vc)
    }
    
    /// Open discounts
    func openDiscounts() {
        
        let vc = DiscountsViewController()
        vc.hidesBottomBarWhenPushed = true
        self.push(vc)
    }
    
    /// Open collection details
    func openCollectionDetails(collectionID :CollectionID) {
        
        let vc = CollectionDetailsViewController()
        vc.collectionID = collectionID
        vc.hidesBottomBarWhenPushed = true
        self.push(vc)
    }
    
    /// Open image gallery
    func openImageGallery(images: [URL]) {
        let vc = ImageGalleryViewController(images: images)
        self.present(vc: vc, presentationStyle: .fullScreen)
    }
    
    /// Open html description
    /// - Parameter string: String
    func openHtmlDescription(_ string: String) {
        let vc = DescriptionDetailsViewController()
        vc.htmlString = string
        self.present(vc: vc, presentationStyle: .formSheet)
    }
}
