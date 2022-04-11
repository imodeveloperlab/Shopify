//
//  SearchCountry1ViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 02.03.2021.
//

import DSKit
import UIKit

final class SearchCountryViewController: DSViewController {
    
    var searchText = ""
    
    var didSelectCountry: ((String) -> Void)?
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        prefersLargeTitles = false
        title = loc("SEARCH_COUNTRY")
        showTop(content: searchTextFieldSection())
        update()
    }
    
    func update() {
        show(content: countries())
    }
}

// MARK: - Search

extension SearchCountryViewController {
    
    func searchTextFieldSection() -> DSSection {
        
        let textField = DSTextFieldVM.search(placeholder: loc("SEARCH_COUNTRY_SEARCH"))
        textField.handleValidation = { text in
            return true
        }
        
        textField.didUpdate = { tf in
            self.searchText = tf.text ?? ""
            self.update()
        }
        
        return textField.list()
    }
    
    func countries() -> DSSection {
        
        var countryList = Locale.isoRegionCodes.compactMap { Locale.current.localizedString(forRegionCode: $0) }
        
        if searchText != "" {
            countryList = countryList.filter({ (country) -> Bool in
                country.lowercased().contains(searchText.lowercased())
            })
        }
        
        let models = countryList.map { (name) -> DSViewModel in
            
            var label = DSLabelVM(.headlineWithSize(15), text: name, alignment: .left)
            label.height = .absolute(30)
            
            // Handle did select country
            label.didTap { [unowned self] (_: DSLabelVM) in
                self.didSelectCountry?(name)
            }
            
            return label
        }
        
        if models.isEmpty {
            
            return getPlaceholderSection(image: UIImage(systemName: "magnifyingglass"), text: "\(loc("SEARCH_COUNTRY_PLACEHOLDER")) \(searchText)")
        }
        
        return models.list(separator: true)
    }
}
