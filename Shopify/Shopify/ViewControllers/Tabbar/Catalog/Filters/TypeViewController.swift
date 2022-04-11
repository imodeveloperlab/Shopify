//
//  TypeViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class TypeViewController: DSViewController {
    
    var selectedType: ProductType? = nil
    var didSelectType: (Done<ProductType>)?
    var removeType: (HandleDidTap)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("TYPE")
        prefersLargeTitles = false
        update()
        
        let button = DSButtonVM(title: loc("TYPE_REMOVE_TYPE")) { _ in
            self.removeType?()
        }
        
        self.showBottom(content: button)
    }
    
    func update() {
                
        self.loading(true)
        let store = StoreTypesAPI()
        store.getTypes(first: 100, success: { types in
            
            self.loading(false)
            
            let viewModels = types.map({ type in
                
                self.option(title: type.readableString(),
                            identifier: type,
                            currentSelected: self.selectedType,
                            didSelect: { new in
                                self.selectedType = new
                                self.didSelectType?(new)
                            })
            })
            
            let section = viewModels.list()
            self.show(content: section)
            
        }, fail: handleFail(stopLoading: true))
    }
}
