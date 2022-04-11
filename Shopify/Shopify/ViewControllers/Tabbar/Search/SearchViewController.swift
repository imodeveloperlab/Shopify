//
//  SearchViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class SearchViewController: DSViewController {
    
    // View models
    var collectionsViewModels: [DSViewModel]?
    var productTypesViewModels: [DSViewModel]?
    var tagsViewModels: [DSViewModel]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("SEARCH")
        setUpSearchViewController()
        updateCollections()
        updateTags()
        updateProductTypes()
    }
    
    func setUpSearchViewController() {
        
        let searchViewController = SearchResultsViewController()

        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchBar.barTintColor = appearance.navigationBar.bar
        searchController.searchBar.tintColor = appearance.navigationBar.text
        
        searchController.searchResultsUpdater = searchViewController
        navigationItem.searchController = searchController
    }
}

// MARK: - Update Server Data

extension SearchViewController {
    
    /// Types
    func updateProductTypes() {
        
        let storeUI = StoreTypesUI()
        
        self.loading(true)
        storeUI.getProductTypesForGallery(success: { viewModels in
            
            self.loading(false)
            self.productTypesViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Update collections
    func updateCollections() {
        
        let storeUI = StoreCollectionsUI()
        
        self.loading(true)
        storeUI.getCollectionsForGallery(first: 100, success: { viewModels in
            
            self.loading(false)
            self.collectionsViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Update tags
    func updateTags() {
        
        let tags = StoreTagsUI()
        
        loading(true)
        tags.getProductTagsForGallery(success: { viewModels in
    
            self.loading(false)
            self.tagsViewModels = viewModels
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
}

// MARK: - Update UI

extension SearchViewController {
    
    // Update UI
    func updateUI() {
        
        var sections = [DSSection]()
        typesSection(&sections)
        collectionsSection(&sections)
        tagsSection(&sections)
        self.show(content: sections)
    }
    
    // Types section
    fileprivate func typesSection(_ sections: inout [DSSection]) {
        
        if var productTypesViewModels = productTypesViewModels {
            
            productTypesViewModels = productTypesViewModels.didTapObject({ (type: ProductType) in
                let filter = ProductFilter(type: type)
                self.openCatalog(filter: filter)
            })
            
            let section = productTypesViewModels.gallery()
            section.headlineHeader(loc("SEARCH_TYPES_HEADER"))
            sections.append(section)
        }
    }
    
    // Collections section
    fileprivate func collectionsSection(_ sections: inout [DSSection]) {
       
        if var collectionsViewModels = collectionsViewModels {
            
            collectionsViewModels = collectionsViewModels.didTapObject({ (id: CollectionID) in
                
                print(id)
                
                self.openCollectionDetails(collectionID: id)
            })
            
            let section = collectionsViewModels.gallery()
            section.headlineHeader(loc("SEARCH_COLLECTIONS_HEADER"))
            sections.append(section)
        }
    }
    
    // Tags section
    fileprivate func tagsSection(_ sections: inout [DSSection]) {
        
        if var tagsViewModels = tagsViewModels {
            
            tagsViewModels = tagsViewModels.didTapObject({ (tag: ProductType) in
                let filter = ProductFilter(tag: tag)
                self.openCatalog(filter: filter)
            })
            
            let section = tagsViewModels.gallery()
            section.headlineHeader(loc("SEARCH_TAGS_HEADER"))
            sections.append(section)
        }
    }
}
