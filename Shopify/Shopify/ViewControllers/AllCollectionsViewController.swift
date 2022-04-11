//
//  AllCollectionsViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class AllCollectionsViewController: DSViewController {
    
    var collectionsViewModels: [DSViewModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("COLLECTIONS")
        updateCollections()
    }
    
    /// Update collections
    func updateCollections() {
        
        let storeUI = StoreCollectionsUI()
        
        self.loading(true)
        
        storeUI.getCollectionsList { viewModels in
            
            self.loading(false)
            
            let viewModels = viewModels.didTapObject { (collectionID :CollectionID) in
                self.openCollectionDetails(collectionID: collectionID)
            }
            
            self.collectionsViewModels = viewModels
            self.updateUI()
            
        } fail: { error in
            
            self.loading(false)
            self.show(message: error.localizedDescription, type: .error)
        }
    }
    
    func updateUI() {
        
        var sections = [DSSection]()
        
        // Collections
        if let collectionsViewModels = collectionsViewModels {
            let section = collectionsViewModels.list()
            sections.append(section)
        }
        
        self.show(content: sections)
    }
}
