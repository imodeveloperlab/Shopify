//
//  SearchResultsViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class SearchResultsViewController: DSViewController , UISearchResultsUpdating {
    
    let products = StoreProductsUI()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = loc("SEARCH_RESULT")
        hideNavigationBar = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text, text != "", text.count > 3 else {
            showPlaceHolder()
            return
        }
        
        products.getSearchProducts(search: text, success: { viewModels in
            
            let section = viewModels.list()
            self.show(content: section)
            
        }, fail: handleFail(stopLoading: true))
    }
    
    func showPlaceHolder() {
        
        self.showPlaceholder(image: UIImage(systemName: "bag"),
                             text: loc("SEARCH_RESULT_PLACEHOLDER"))
    }
}
