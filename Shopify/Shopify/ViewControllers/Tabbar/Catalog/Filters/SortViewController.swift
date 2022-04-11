//
//  SortViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class SortViewController: DSViewController {
    
    var selectedOption: SortOption? = nil
    var didSelectOption: (Done<SortOption>)?
    var removeSort: (HandleDidTap)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("SORT")
        prefersLargeTitles = false
        
        let button = DSButtonVM(title: loc("SORT_REMOVE_SORT")) { _ in
            self.removeSort?()
        }
        
        self.showBottom(content: button)
        
        update()
    }
    
    func update() {
        
        let store = StoreProductsAPI()
        self.loading(true)
        store.getProductSortKeys(success: { sort in
            
            self.loading(false)
            
            let viewModels = sort.map { key -> DSViewModel in
                
                self.option(title: key.rawValue.readableString(),
                            identifier: key.rawValue,
                            currentSelected: self.selectedOption,
                            didSelect: { new in
                                self.selectedOption = new
                                self.didSelectOption?(new)
                            })
            }
            
            self.show(content: viewModels.list())
            
        }, fail: handleFail(stopLoading: true))
    }
}
