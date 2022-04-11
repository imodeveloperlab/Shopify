//
//  CollectionViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class CollectionViewController: DSViewController {
    
    var didSelectCollection: (Done<ProductCollection>)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("COLLECTION")
        prefersLargeTitles = false
        update()
    }
    
    func update() {
        
        let collection = StoreCollectionsUI()
        
        loading(true)
        collection.getCollectionsList(success: { viewModels in
            
            let viewModels = viewModels.didTapObject { [unowned self] (collection: ProductCollection) in
                self.didSelectCollection?(collection)
            }
            
            self.loading(false)
            let section = viewModels.list()
            self.show(content: section)
            
        }, fail: handleFail(stopLoading: true))
    }
}
