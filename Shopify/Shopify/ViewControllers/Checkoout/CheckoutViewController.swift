//
//  CheckoutViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import Buy

final class CheckoutViewController: DSViewController {
    
    var checkout: Storefront.Checkout?
    let searchCountry = SearchCountryViewController()
    
    var saveAddressForNextTime: Bool = true
    var keepMeUpToDateOnNews: Bool = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("CHECKOUT")
        update()
    }
    
    func update() {
        
        // If checkout object is nil we will generate new checkout object
        if checkout == nil {
            prepareCheckout()
        } else {
            showInformationForm()
        }
    }
    
    func showInformationForm() {
        
        var sections = [DSSection]()
        
        // Contact information section
        sections.append(contentsOf: [header(title: loc("CHECKOUT_CONTACT_INFORMATION")).list(),
                                     emailAddressTextField().list(),
                                     keepMeUpToDateSection()])
        
        if Cart.shared.isShippingRequired() {
            
            // Name
            let nameSection = [firstNameTextField(),
                               lastNameTextField()]
            
            // City
            let citySection = [postalCodeTextField(),
                               cityTextField()]
            
            // Address
            let addressSection = [addressTextField(),
                                  apartmentSuiteTextField()]
            
            // Country
            let countrySection = [countryTextField()]
            
            // Address section
            sections.append(contentsOf: [header(title: loc("CHECKOUT_SHIPPING_ADDRESS")).list(),
                                         nameSection.grid(),
                                         addressSection.list().interItemTopInset(),
                                         citySection.grid(),
                                         countrySection.list().interItemTopInset(),
                                         saveAddressSection()])
        }
        
        // Show form
        self.show(content: sections)
        
        // Show bottom content, next step button
        self.showBottom(content: bottomContentSection())
    }
}

// MARK: - Next Step

extension CheckoutViewController {
    
    /// Bottom content section
    /// - Returns: DSSection
    func bottomContentSection() -> DSSection {
        
        let icon = DSSFSymbolConfig.buttonIcon("arrow.right")
        var button = DSButtonVM(title: loc("CHECKOUT_CONTINUE_TO_SHIPPING"), icon: icon) { [unowned self] _ in
            self.validateFormAndProceedToCheckoutAction()
        }
        
        button.textAlignment = .left
        button.imagePosition = .rightMargin
        
        let section = button.list().subheadlineHeader(loc("CHECKOUT_NEXT_STEP_SHIPPING"))
        return section
    }
    
    /// Validate form and proceed to checkout
    func validateFormAndProceedToCheckoutAction() {
        
        // Check if current form is valid
        self.isCurrentFormValid { isValid in
            
            if isValid {
                self.checkoutAction()
            } else {
                self.reloadAllContent()
                self.show(message: self.loc("CHECKOUT_INVALID_FORM"), type: .error, timeOut: 1)
            }
        }
    }
    
    /// Checkout
    func checkoutAction() {
        
        let checkoutAPI = StoreCheckoutAPI()
        
        // Email
        guard let email = User.shared.userPhoneNumberOrEmail else {
            return
        }
        
        // Checkout object
        guard let checkout = self.checkout else {
            return
        }
        
        self.loading(true)
        
        // Update email address in checkout object
        checkoutAPI.updateEmail(email: email, checkout: checkout, success: {
            
            // Update shipping address in checkout object
            checkoutAPI.updateShippingAddress(address: User.shared.address, checkout: checkout, success: {
                
                // Save user data
                if self.saveAddressForNextTime {
                    User.shared.saveData()
                }
                
                self.loading(false)
                
                // Open shipping step
                self.push(ShippingViewController(checkout: checkout))
                
            }, fail: self.handleFail(stopLoading: true))
            
        }, fail: self.handleFail(stopLoading: true))
    }
}

// MARK: - Checkout

extension CheckoutViewController {
    
    func prepareCheckout() {
        
        let api = StoreCheckoutAPI()
        self.loading(true)
        api.prepareForCheckout(products: Cart.shared.allProducts(), success: { checkout in
            
            self.checkout = checkout
            self.loading(false)
            self.update()
            
        }, fail: handleFail(stopLoading: true))
    }
}

// MARK: - Contact Information

extension CheckoutViewController {
    
    /// Email address text field
    /// - Returns: DSViewModel
    func emailAddressTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM.email(text: User.shared.userPhoneNumberOrEmail, placeholder: loc("CHECKOUT_EMAIL_ADDRESS"))
        textField.didUpdate = { textField in
            User.shared.userPhoneNumberOrEmail = textField.text
        }
        
        return textField
    }
    
    // Keep me up to date on news and exclusive offers
    func keepMeUpToDateSection() -> DSSection {
        
        var label = DSLabelVM(.subheadlineWithSize(15), text: loc("CHECKOUT_UP_TO_DATE"))
        var switchView = DSSwitchVM(isOn: saveAddressForNextTime)
        switchView.didUpdate = { isOn in
            self.keepMeUpToDateOnNews = isOn
        }
        
        label.rightSideView = DSSideView(view: switchView)
        label.height = .absolute(30)
        
        return label.list()
    }
}

// MARK: - Shipping form

extension CheckoutViewController {
    
    /// First name
    /// - Returns: DSViewModel
    func firstNameTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM.givenName(text: User.shared.address.firstNameValue,
                                                placeholder: loc("CHECKOUT_FIRST_NAME"))
        
        textField.didUpdate = { textField in
            User.shared.address.firstNameValue = textField.text
        }
        
        return textField
    }
    
    /// Last name
    /// - Returns: DSViewModel
    func lastNameTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM.familyName(text: User.shared.address.lastNameValue,
                                                 placeholder: loc("CHECKOUT_LAST_NAME"))
        
        textField.didUpdate = { textField in
            User.shared.address.lastNameValue = textField.text
        }
        
        textField.leftSFSymbolName = nil
        
        return textField
    }
    
    /// Address text field
    /// - Returns: DSViewModel
    func addressTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM.address(text: User.shared.address.addressValue,
                                              placeholder: loc("CHECKOUT_ADDRESS"))
        
        textField.didUpdate = { textField in
            User.shared.address.addressValue = textField.text
        }
        
        return textField
    }
    
    /// Apartment and suite text field
    /// - Returns: DSViewModel
    func apartmentSuiteTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM.address(text: User.shared.address.apartamentSuiteValue,
                                              placeholder: loc("CHECKOUT_APARTMENT"))
        
        textField.didUpdate = { textField in
            User.shared.address.apartamentSuiteValue = textField.text
        }
        
        textField.handleValidation = { tf in
            return true
        }
        
        return textField
    }
    
    /// City textfield
    /// - Returns: DSViewModel
    func cityTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM.addressCity(text: User.shared.address.cityValue,
                                                  placeholder: loc("CHECKOUT_CITY"))
        
        textField.didUpdate = { textField in
            User.shared.address.cityValue = textField.text
        }
        
        return textField
    }
    
    // Address Country Text Field
    func countryTextField() -> DSViewModel {
        
        // Text field
        let textField = DSTextFieldVM(text: User.shared.address.countryNameValue,
                                      placeholder: loc("CHECKOUT_COUNTRY"))
        
        textField.leftSFSymbolName = "globe"
        textField.validationPattern = patternAddress
        textField.validateMinimumLength = 3
        textField.validateMaximumLength = 120
        
        // Update
        textField.didTap = { [unowned self] textField in
            
            // User did select country in searchCountry view controller
            self.searchCountry.didSelectCountry = { [unowned self] countryName in
                User.shared.address.countryNameValue = countryName
                self.searchCountry.dismiss()
                self.update()
            }
            
            // Present search country view controller
            self.present(vc: self.searchCountry, presentationStyle: .formSheet)
        }
        
        return textField
    }
    
    // Postal code text field
    func postalCodeTextField() -> DSViewModel {
        
        let textField = DSTextFieldVM(text: User.shared.address.postalCodeValue,
                                      placeholder: loc("CHECKOUT_POSTAL_CODE"))
        
        textField.didUpdate = { textField in
            User.shared.address.postalCodeValue = textField.text
        }
        
        textField.leftSFSymbolName = "signpost.left"
        
        // Validation
        textField.validationPattern = patternAddress
        textField.validateMinimumLength = 3
        textField.validateMaximumLength = 10
        return textField
    }
    
    // Save card for future transaction
    func saveAddressSection() -> DSSection {
        
        var label = DSLabelVM(.subheadlineWithSize(15),
                              text: loc("CHECKOUT_SAVE_CHECKOUT_INFORMATION"))
        
        var switchView = DSSwitchVM(isOn: saveAddressForNextTime)
        switchView.didUpdate = { isOn in
            self.saveAddressForNextTime = isOn
        }
        
        label.rightSideView = DSSideView(view: switchView)
        label.height = .absolute(30)
        
        return label.list()
    }
}

// MARK: - Helpers

extension CheckoutViewController {
    
    /// Header
    /// - Parameter title: String
    /// - Returns: DSViewModel
    func header(title: String) -> DSViewModel {
        return DSLabelVM(.headline, text: title)
    }
}
