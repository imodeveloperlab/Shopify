//
//  InfoViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class TagViewController: DSViewController {
    
    var selectedTag: ProductTag?
    var didSelectTag: (Done<ProductTag>)?
    var removeTag: (HandleDidTap)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("TAGS")
        prefersLargeTitles = false
        update()
        
        let button = DSButtonVM(title: loc("TAGS_REMOVE_TAGS")) { _ in
            self.removeTag?()
        }
        
        self.showBottom(content: button)
        update()
    }
    
    func update() {
        
        let tags = StoreTagsAPI()
        loading(true)
        tags.getTags(first: 100, success: { tags in
            
            self.loading(false)
            let viewModels = tags.map({ tag in
                
                self.option(title: tag.readableString(),
                            identifier: tag,
                            currentSelected: self.selectedTag,
                            didSelect: { new in
                                self.selectedTag = new
                                self.didSelectTag?(new)
                            })
            })
            
            self.show(content: viewModels.list())
            
        }, fail: handleFail(stopLoading: true))
    }
}
