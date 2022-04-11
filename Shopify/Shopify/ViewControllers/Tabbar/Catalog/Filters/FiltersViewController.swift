//
//  FiltersViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 02.03.2021.
//

import DSKit

final class FiltersViewController: DSViewController {
    
    // View models
    var productTypes: [ProductType]?
    var productSort: [SortOption]?
    var tags: [ProductTag]?
    var filter = ProductFilter()
    var didSelectFilter: (Done<ProductFilter>)?
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("FILTERS")
        
        // Reset
        let reset = UIBarButtonItem(title: loc("FILTERS_RESET"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(resetAction))
        
        navigationItem.rightBarButtonItems = [reset]
        
        update()
    }
    
    func update() {
        
        updateTags()
        updateProductTypes()
        updateSort()
    }
    
    @objc func resetAction() {
        self.filter = ProductFilter()
        update()
    }
}

// MARK: - Update Server Data

extension FiltersViewController {
    
    /// Sort
    func updateSort() {
        
        let store = StoreProductsAPI()
        
        self.loading(true)
        store.getProductSortKeys(success: { sort in
            
            self.productSort = sort.map({ key in
                key.rawValue
            })
            
            self.loading(false)
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Types
    func updateProductTypes() {
        
        let store = StoreTypesAPI()
        
        self.loading(true)
        store.getTypes(first: 100, success: { types in
            
            self.productTypes = types
            self.loading(false)
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
    
    /// Update tags
    func updateTags() {
        
        let tags = StoreTagsAPI()
        loading(true)
        tags.getTags(first: 100, success: { tags in
            
            self.tags = tags
            self.loading(false)
            self.updateUI()
            
        }, fail: handleFail(stopLoading: true))
    }
}

// MARK: - Update UI

extension FiltersViewController {
    
    // Update UI
    func updateUI() {
        
        var sections = [DSSection]()
        sortSection(&sections)
        typesSection(&sections)
        tagsSection(&sections)
        self.show(content: sections)
        
        if self.filter.noOptionsSelected() {
            
            let button = DSButtonVM(title: loc("FILTERS_CLOSE")) { [unowned self] _ in
                didSelectFilter?(self.filter)
            }
            
            self.showBottom(content: button)
            
        } else {
            
            let button = DSButtonVM(title: loc("FILTERS_SHOW_RESULTS")) { [unowned self] _ in
                didSelectFilter?(self.filter)
            }
            
            self.showBottom(content: button)
        }
    }
    
    // Types section
    fileprivate func typesSection(_ sections: inout [DSSection]) {
        
        guard let productTypes = productTypes else {
            return
        }
        
        let viewModels = productTypes.map({ type in
            
            self.option(title: type.readableString(),
                        identifier: type,
                        currentSelected: self.filter.type,
                        didSelect: { new in
                            self.filter.type = new
                            self.updateUI()
                        })
        })
        
        let section = viewModels.grid()
        section.headlineHeader(loc("FILTERS_TYPES"))
        sections.append(section)
    }
    
    // Sort section
    fileprivate func sortSection(_ sections: inout [DSSection]) {
        
        guard let productSort = productSort else {
            return
        }
        
        let viewModels = productSort.map { key -> DSViewModel in
            self.option(title: key.readableString(),
                        identifier: key,
                        currentSelected: self.filter.sort,
                        didSelect: { new in
                            self.filter.sort = new
                            self.updateUI()
                        })
        }
        
        let section = viewModels.grid()
        section.headlineHeader(loc("FILTERS_SORT"))
        sections.append(section)
    }
    
    // Tags section
    fileprivate func tagsSection(_ sections: inout [DSSection]) {
        
        guard let tags = tags else {
            return
        }
        
        let viewModels = tags.map({ tag in
            
            self.option(title: tag.readableString(),
                        identifier: tag,
                        currentSelected: self.filter.tag,
                        didSelect: { new in
                            self.filter.tag = new
                            self.updateUI()
                        })
        })
        
        let section = viewModels.list()
        section.headlineHeader(loc("FILTERS_TAGS"))
        sections.append(section)
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct FiltersViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            let nav = DSNavigationViewController(rootViewController: FiltersViewController())
            PreviewContainer(VC: nav).edgesIgnoringSafeArea(.all)
        }
    }
}
