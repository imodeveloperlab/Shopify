//
//  ProductDetailsViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import Buy

final class ProductDetailsViewController: DSViewController {
    
    var productId: ProductID?
    var selectedOptions = [Storefront.SelectedOptionInput]()
    var selectedVariant: Storefront.ProductVariant?
    var lastResponse: (product: Storefront.Product, images: [Storefront.Image], variants: [Storefront.ProductVariant])?
    var selectedQuantity: Int32 = 1
    
    var prepareOptions = true
    var loading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("PRODUCT_DETAILS")
        showCartInNavigationBar()
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func update() {
        
        guard let id = productId else {
            return
        }
        
        let api = StoreProductsAPI()
        
        self.loading(loading)
        api.getProduct(productID: id, selectedOptions: selectedOptions, success: { response in
            
            self.loading = false
            self.lastResponse = response
            
            // Current selected variant
            if let variant = response.product.variantBySelectedOptions {
                self.selectedVariant = variant
            } else {
                self.selectedVariant = nil
            }
            
            if self.prepareOptions {
                
                self.prepareOptions = false
                self.selectedVariant = response.variants.first
                
                // Current selected options
                if let options = self.selectedVariant?.selectedOptions {
                    self.selectedOptions = [Storefront.SelectedOptionInput]()
                    for option in options {
                        self.selectedOptions.append(Storefront.SelectedOptionInput(name: option.name, value: option.value))
                    }
                }
                
                self.update()
            }
            
            self.loading(false)
            self.updateUI(data: response)
            
            
        }, fail: handleFail(stopLoading: true))
    }
    
    func updateUI(data: (product: Storefront.Product,
                         images: [Storefront.Image],
                         variants: [Storefront.ProductVariant])) {
        
        var sections = [DSSection]()
        
        // Gallery
        let gallery = picturesGallerySection(images: data.images)
        sections.append(gallery)
        
        // Product info
        let productInfo = productInfoSection(product: data.product)
        sections.append(productInfo)
        
        // Price
        if let variant = self.selectedVariant {
            let price = priceSection(variant: variant)
            sections.append(price)
        }
        
        // Options
        for option in data.product.options {
            sections.append(optionSection(option: option))
        }
        
        // Description
        let description = descriptionSection(product: data.product)
        sections.append(description)
        self.show(content: sections)
        
        // Bottom buttons
        if let variant = self.selectedVariant {
            
            if variant.availableForSale {
                showAddToCard()
            } else {
                showUnavailable()
            }
            
        } else {
            
            showUnavailable()
        }
    }
    
    func showAddToCard() {
        
        // Add to cart button
        let addToCart = DSButtonVM(title: loc("PRODUCT_DETAILS_ADD_TO_CART_BUTTON"), type: .cleanWithBorder) { [unowned self] tap in
            
            guard let product = self.lastResponse?.product else {
                return
            }
            
            self.show(message: loc("PRODUCT_DETAILS_ADDED_TO_CART"), type: .success, icon: UIImage(systemName: "checkmark.circle.fill")) {
                
                // Add Product to cart
                let cartProduct = CartProduct(quantity: self.selectedQuantity, product: product, id: UUID())
                Cart.shared.addProduct(product: cartProduct)
            }
        }
        
        // Add to cart button
        let buyNow = DSButtonVM(title: loc("PRODUCT_DETAILS_BUY_NOW")) { [unowned self] tap in
            
            guard let product = self.lastResponse?.product else {
                return
            }
            
            // Add Product to cart
            let cartProduct = CartProduct(quantity: self.selectedQuantity, product: product, id: UUID())
            Cart.shared.addProduct(product: cartProduct)
            self.push(CartViewController())
        }
        
        // Show bottom content
        showBottom(content: [addToCart, buyNow].grid())
    }
    
    func showUnavailable() {
        
        let addToCart = DSButtonVM(title: loc("PRODUCT_DETAILS_UNAVAILABLE_BUTTON"), type: .cleanWithBorder) { [unowned self] tap in
            
            self.show(message: loc("PRODUCT_DETAILS_UNAVAILABLE_MESSAGE"),
                      type: .error,
                      timeOut: 2,
                      icon: UIImage(systemName: "magnifyingglass"))
        }
        
        // Show bottom content
        showBottom(content: addToCart)
    }
    
    /// Product info section
    /// - Returns: DSSection
    func productInfoSection(product: Storefront.Product) -> DSSection {
        
        let composer = DSTextComposer()
        composer.add(type: .title2, text: product.title.readableString())
        composer.add(type: .subheadline, text: product.productType.readableString())
        return [composer.textViewModel()].list()
    }
    
    /// Price section
    /// - Returns: DSSection
    func priceSection(variant: Storefront.ProductVariant) -> DSSection {
        
        // Text
        let text = DSTextComposer()
        if let price = variant.price() {
            text.add(price: price, size: .large, newLine: false)
        }
        
        text.add(type: .body, text: loc("PRODUCT_DETAILS_TAX_INCLUDED"))
        
        // Action
        var action = DSActionVM(composer: text)
        action.style.displayStyle = .default
        
        // Picker
        let picker = DSQuantityPickerVM(quantity: Int(selectedQuantity))
        picker.width = .absolute(120)
        picker.height = .absolute(35)
        picker.quantityDidUpdate = { quantity in
            self.selectedQuantity = Int32(quantity)
        }
        
        // Supplementary view
        let supView = picker.asSupplementary(position: .rightCenter,
                                             insets: .small,
                                             offset: .custom(.init(x: -5, y: 0)))
        
        action.supplementaryItems = [supView]
        
        return action.list()
    }
    
    /// Gallery section
    /// - Returns: DSSection
    func picturesGallerySection(images: [Storefront.Image]) -> DSSection {
        
        let urls = images.map { image in
            image.originalSrc
        }
        
        let pictureModels = urls.map { url -> DSViewModel in
            
            var imageVM = DSImageVM(imageUrl: url, height: .absolute(300), displayStyle: .themeCornerRadius)
            imageVM.style.borderStyle = .custom(width: 0.5, color: .separator.withAlphaComponent(0.2))
            imageVM.didTap = { [unowned self] _ in
                self.openImageGallery(images: urls)
            }
            
            return imageVM
        }
        
        let pageControl = DSPageControlVM(type: .viewModels(pictureModels))
        
        return pageControl.list().zeroLeftRightInset()
    }
    
    /// Description
    /// - Returns: DSSection
    func descriptionSection(product: Storefront.Product) -> DSSection {
        
        let text = product.description.maxLength(length: 150)
        
        var label = DSActiveTextVM(.callout, text: "\(text) \(loc("PRODUCT_DETAILS_READ_MORE"))", alignment: .left)
        label.links = [loc("PRODUCT_DETAILS_READ_MORE"): "https://www.dskit.app"]
        label.didTapOnUrl = { [unowned self] url in
            self.openHtmlDescription(product.descriptionHtml)
        }
        
        return [label].list()
    }
    
    /// Gallery section
    /// - Returns: DSSection
    func optionSection(option: Storefront.ProductOption) -> DSSection {
        
        let valueModels = option.values.map { (value) -> DSViewModel in
            
            // Is selected
            var isSelected = false
            
            for possibleOption in self.selectedOptions {
                if option.name == possibleOption.name &&
                    value == possibleOption.value {
                    isSelected = true
                    break
                }
            }
            
            // Label
            var label = DSLabelVM(.headlineWithSize(12), text: value.readableString(), alignment: .center)
            label.style.displayStyle = .grouped(inSection: false)
            label.style.borderStyle = isSelected ? .brandColor : .none
            
            // Handle tap
            label.didTap { [unowned self] (_: DSLabelVM) in
                
                // Did select new option
                self.selectedOptions.removeAll { currentOption in
                    currentOption.name == option.name
                }
                
                self.selectedOptions.append(Storefront.SelectedOptionInput(name: option.name, value: value))
                self.updateSelectedVariantFromCurrentSelectedOptions()
                
                self.selectedQuantity = 1
                
                if let response = self.lastResponse {
                    self.updateUI(data: response)
                }
                
                self.update()
            }
            
            return label
        }
        
        var columns = 2
        
        if valueModels.count > 4 {
            columns = 4
        } else {
            columns = valueModels.count
        }
        
        return valueModels.grid(columns: columns).subheadlineHeader(option.name.readableString())
    }
    
    func updateSelectedVariantFromCurrentSelectedOptions() {
        
        guard let response = self.lastResponse else {
            return
        }
        
        for variant in response.variants {
            
            let variantSelectedOptionsSorted = variant.selectedOptions.sorted { a, b in
                a.name < b.name
            }
            
            let selectedOptionsToSelectedOptionsSorted = self.selectedOptions.toSelectedOptions().sorted { a, b in
                a.name < b.name
            }
            
            if variantSelectedOptionsSorted == selectedOptionsToSelectedOptionsSorted {
                self.selectedVariant = variant
            }
        }
    }
}

extension Array where Element == Storefront.SelectedOptionInput {
    
    func toSelectedOptions() -> [Storefront.SelectedOption] {
        
        return self.map { input -> Storefront.SelectedOption? in
            
            do {
                return try Storefront.SelectedOption(fields: ["name" : input.name, "value": input.value])
            } catch {
                print(error)
            }
            
            return nil
            
        }.compactMap({ $0 })
    }    
}

extension Storefront.SelectedOptionInput: Equatable {
    
    public static func == (lhs: Storefront.SelectedOptionInput, rhs: Storefront.SelectedOptionInput) -> Bool {
        lhs.name == rhs.name &&
            lhs.value == rhs.value
    }
}

extension Storefront.SelectedOption: Equatable {
    
    public static func == (lhs: Storefront.SelectedOption, rhs: Storefront.SelectedOption) -> Bool {
        lhs.name == rhs.name &&
            lhs.value == rhs.value
    }
}
