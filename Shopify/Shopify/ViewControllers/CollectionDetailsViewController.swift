//
//  CollectionDetailsViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class CollectionDetailsViewController: DSViewController {
    
    var collectionID :CollectionID?
    let collections = StoreCollectionsAPI()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = nil
        
        guard let id = collectionID else {
            return
        }
        
        let ui = ProductViewModels()
        
        self.loading(true)
        collections.getCollectionAndProducts(collectionID: id, success: { response in
            
            self.loading(false)
            
            self.title = response.collection.title
            
            let viewModels = response.products.map { product -> DSViewModel in
                
                var viewModel = ui.bigProduct(title: product.title,
                                              description: product.description.maxLength(length: 45),
                                              image: product.coverImage(),
                                              price: product.firstPrice(),
                                              object: product.id.rawValue as AnyObject)
                
                viewModel.didTapObject { (productId: ProductID) in
                    self.openProductDetails(productId: productId)
                }
                
                return viewModel
            }
            
            self.show(content: viewModels.list())
            
        }, fail: handleFail(stopLoading: true))
    }
}
