//
//  CatalogViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

final class CatalogViewController: DSViewController {
    
    var filter = ProductFilter()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("CATALOG")
        
        // Sort
        let filters = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(openFilters))
        
        navigationItem.rightBarButtonItems = [filters]
        navigationController?.setStatusBar(backgroundColor: self.view.backgroundColor)
        
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // Open filters
    @objc func openFilters() {
        
        let filtersVC = FiltersViewController()
        filtersVC.filter = self.filter
        
        filtersVC.didSelectFilter = { [unowned self] filter in
            
            self.filter = filter
            filtersVC.dismiss()
            self.update()
        }
        
        let navVC = DSNavigationViewController(rootViewController: filtersVC)
        self.present(vc: navVC, presentationStyle: .formSheet)
    }
    
    // Open type
    @objc func openType() {
        
        let typeVC = TypeViewController()
        typeVC.selectedType = self.filter.type
        
        typeVC.didSelectType = { [unowned self] type in
            
            self.filter.type = type
            typeVC.dismiss()
            self.update()
        }
        
        typeVC.removeType = {  [unowned self] in
            
            self.filter.type = nil
            typeVC.dismiss()
            self.update()
        }
        
        let navVC = DSNavigationViewController(rootViewController: typeVC)
        self.present(vc: navVC, presentationStyle: .formSheet)
    }
    
    // Open tags
    @objc func openTags() {
        
        let tagVC = TagViewController()
        tagVC.selectedTag = self.filter.tag
        
        tagVC.didSelectTag = { [unowned self] tag in
            
            self.filter.tag = tag
            tagVC.dismiss()
            self.update()
        }
        
        tagVC.removeTag = { [unowned self] in
            
            self.filter.tag = nil
            tagVC.dismiss()
            self.update()
        }
        
        let navVC = DSNavigationViewController(rootViewController: tagVC)
        self.present(vc: navVC, presentationStyle: .formSheet)
    }
    
    // Open sort
    @objc func openSort() {
        
        let sortVC = SortViewController()
        sortVC.selectedOption = self.filter.sort
        sortVC.didSelectOption = { [unowned self] option in
            
            self.filter.sort = option
            sortVC.dismiss()
            self.update()
        }
        
        sortVC.removeSort = { [unowned self] in
            
            self.filter.sort = nil
            sortVC.dismiss()
            self.update()
        }
        
        let navVC = DSNavigationViewController(rootViewController: sortVC)
        self.present(vc: navVC, presentationStyle: .formSheet)
    }
    
    // Update UI
    func update() {
        
        let storeUI = StoreProductsUI()
        
        loading(true)
        storeUI.getProducts(filter: filter, success: { products in
            
            let products = products.didTapObject { (productId: ProductID) in
                self.openProductDetails(productId: productId)
            }
            
            let section = products.grid()
            self.show(content: section)
            self.loading(false)
            
        }, fail: { error in
            
            print(error)
            self.loading(false)
            self.show(message: error.localizedDescription, type: .error)
            
        })
        
        updateFilters()
    }
    
    // Filters
    func updateFilters() {
        
        var viewModels = [DSViewModel]()
        
        // Filter By
        if let filterByOption = filterByOption() {
            viewModels.append(filterByOption)
        }
        
        // Sort By
        if let sortByOption = sortByOption() {
            viewModels.append(sortByOption)
        }
        
        // Type
        if let typeOption = typeOption() {
            viewModels.append(typeOption)
        }
        
        if viewModels.isEmpty {
            self.hideTopContent()
        } else {
            
            if viewModels.count > 1 {
                showTop(content: viewModels.grid())
            } else {
                showTop(content: viewModels.list())
            }
        }
    }
}

extension CatalogViewController {
    
    // Filter by
    func filterByOption() -> DSViewModel? {
        
        if let tag = filter.tag {
            
            let model = option(title: loc("CATALOG_FILTER_BY_TAG"), option: tag.readableString()) {
                self.openTags()
            } handleRemove: {
                self.filter.tag = nil
                self.update()
            }
            
            return model
        }
        
        return nil
    }
    
    // Sort by
    func sortByOption() -> DSViewModel? {
        
        if let sort = filter.sort {
            
            let model = option(title: loc("CATALOG_FILTER_BY_SORT"), option: sort.readableString()) {
                self.openSort()
            } handleRemove: {
                self.filter.sort = nil
                self.update()
            }
            
            return model
        }
        
        return nil
    }
    
    // Product type
    func typeOption() -> DSViewModel? {
        
        if let type = filter.type {
            
            let model = option(title: loc("CATALOG_FILTER_BY_TYPE"), option: type.readableString()) {
                self.openType()
            } handleRemove: {
                self.filter.type = nil
                self.update()
            }
            
            return model
        }
        
        return nil
    }
    
    /// Option
    /// - Parameters:
    ///   - title: String
    ///   - option: String
    ///   - handle: HandleDidTap
    ///   - handleRemove: HandleDidTap
    /// - Returns: DSViewModel
    func option(title: String,
                option: String,
                handle: @escaping HandleDidTap,
                handleRemove: @escaping HandleDidTap) -> DSViewModel {
        
        // Text
        let composer = DSTextComposer()
        composer.add(type: .headlineWithSize(12), text: title)
        composer.add(type: .subheadlineWithSize(12), text: " \(option)", newLine: false)
        
        // Button
        var button = DSButtonVM(sfSymbol: "xmark", type: .linkBlack)
        button.width = .absolute(25)
        button.height = .absolute(25)
        button.didTap { _ in
            handleRemove()
        }
        
        // Action
        var action = composer.actionViewModel()
        action.rightSideView = DSSideView(view: button)
        action.object = option as AnyObject
        
        action.didTap { _ in
            handle()
        }
        
        return action
    }
}

// MARK: - SwiftUI Preview

import SwiftUI

struct CatalogViewControllerPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            PreviewContainer(VC: CatalogViewController(), nil, true).edgesIgnoringSafeArea(.all)
        }
    }
}
