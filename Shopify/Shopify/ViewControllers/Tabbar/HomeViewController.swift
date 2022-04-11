//
//  HomeViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class HomeViewController: DSViewController {
    
    // View models
    var galleryViewModels: [DSViewModel]?
    var collectionsViewModels: [DSViewModel]?
    var discountsViewModels: [DSViewModel]?
    var productTypesViewModels: [DSViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("HOME")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        updateData()
    }
}

// MARK: - Update UI

extension HomeViewController {
    
    // Update UI
    fileprivate func updateUI() {
        
        var sections = [DSSection]()
        gallerySection(&sections)
        typesSection(&sections)
        discountsSection(&sections)
        collections(&sections)
        show(content: sections)
    }
    
    /// Gallery section
    /// - Parameter sections: [DSSection]
    fileprivate func gallerySection(_ sections: inout [DSSection]) {
        
        if var galleryViewModels = galleryViewModels {
            
            galleryViewModels = galleryViewModels.didTapObject({ (productId: ProductID) in
                self.openProductDetails(productId: productId)
            })
            
            let pageControll = DSPageControlVM(type: .viewModels(galleryViewModels))
            sections.append(pageControll.list().zeroLeftRightInset())
        }
    }
    
    /// Types section
    /// - Parameter sections: [DSSection]
    fileprivate func typesSection(_ sections: inout [DSSection]) {
        
        if var productTypesViewModels = productTypesViewModels {
            
            productTypesViewModels = productTypesViewModels.didTapObject({ (productType: ProductType) in
                
                let filter = ProductFilter(type: productType)
                self.openCatalog(filter: filter)
            })
            
            sections.append(productTypesViewModels.gallery())
        }
    }
    
    /// Discounts section
    /// - Parameter sections: [DSSection]
    fileprivate func discountsSection(_ sections: inout [DSSection]) {
        
        if var discountsViewModels = discountsViewModels {
            
            discountsViewModels = discountsViewModels.didTapObject({ (productId: String) in
                self.openProductDetails(productId: productId)
            })
            
            let section = discountsViewModels.grid()
            
            section.header = header(title: loc("HOME_DISCOUNTS_HEADER"), handle: {
                self.openDiscounts()
            })
            sections.append(section)
        }
    }
    
    /// Collections section
    /// - Parameter sections: [DSSection]
    fileprivate func collections(_ sections: inout [DSSection]) {
        
        if var collectionsViewModels = collectionsViewModels {
            
            collectionsViewModels = collectionsViewModels.didTapObject{ (collectionID :CollectionID) in
                self.openCollectionDetails(collectionID: collectionID)
            }
            
            let section = collectionsViewModels.grid()
            
            section.header = header(title: loc("HOME_COLLECTIONS_HEADER"), handle: {
                self.push(AllCollectionsViewController())
            })
            sections.append(section)
        }
    }
}

// MARK: - Update Server Data

extension HomeViewController {
    
    /// Update data
    fileprivate func updateData() {
        
        updateTopProducts()
        updateCollections()
        updateDiscounts()
        updateProductTypes()
    }
    
    /// Top products
    fileprivate func updateTopProducts() {
        
        let storeUI = StoreProductsUI()
        
        self.loading(true)
        storeUI.getTopProductsWithTitleAndPriceGallery(success: { viewModels in
            
            self.loading(false)
            self.galleryViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Types
    fileprivate func updateProductTypes() {
        
        let storeUI = StoreTypesUI()
        
        self.loading(true)
        storeUI.getProductTypesForGallery(success: { viewModels in
            
            self.loading(false)
            self.productTypesViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Update collections
    fileprivate func updateCollections() {
        
        let storeUI = StoreCollectionsUI()
        
        self.loading(true)
        
        storeUI.getTopCollections(first: 6, success: { viewModels in
            
            self.loading(false)
            self.collectionsViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Update discounts
    fileprivate func updateDiscounts() {
        
        let storeUI = StoreProductsUI()
        self.loading(true)
        storeUI.getDiscountProducts(count: 4, success: { viewModels in
            
            self.loading(false)
            self.discountsViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
}
