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
import SafariServices

final class InfoViewController: DSViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = loc("INFO")
        
        let legals = [privacyPolicy(), termsAndConditions()].list().headlineHeader(loc("INFO_LEGALS"))
        
        let socialMedia = [twitter(),
                           facebook(),
                           instagram()].list().headlineHeader(loc("INFO_SOCIAL_MEDIA"))
        
        let other = [changeLog(), pricing(),  contacts()].list().headlineHeader(loc("INFO_OTHER"))
        
        show(content:  legals, socialMedia, other)
    }
    
    // Privacy policy action
    func privacyPolicy() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_PRIVACY_POLICY"), icon: "lock.shield")
        
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_PRIVACY_POLICY_URL"))
        }
        
        return themeVM
    }
    
    // Terms and conditions action
    func termsAndConditions() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_TERMS_ASD_CONDITIONS"), icon: "doc.text")
        
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_TERMS_ASD_CONDITIONS_URL"))
        }
        
        return themeVM
    }
    
    // Twitter action
    func twitter() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_TWITTER"), image: "twitter", tint: UIColor(0x08a0e9))
        
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_TWITTER_URL"))
        }
        
        return themeVM
    }
    
    // Facebook action
    func facebook() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_FACEBOOK"), image: "facebook", tint: UIColor(0x3b5998))
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_FACEBOOK_URL"))
        }
        
        return themeVM
    }
    
    // Instagram
    func instagram() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_INSTAGRAM"), image: "instagram", tint: UIColor(0xdd2A7B))
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_INSTAGRAM_URL"))
        }
        
        return themeVM
    }
    
    // Change log
    func changeLog() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_CHANGE_LOG"), icon: "doc.text.magnifyingglass")
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: "https://dskit.app/changelog.html")
        }
        
        return themeVM
    }
    
    // Pricing
    func pricing() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_PRICING"), icon: "tag")
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_PRICING_URL"))
        }
        
        return themeVM
    }
    
    // Contacts
    func contacts() -> DSViewModel {
        
        var themeVM = article(title: loc("INFO_CONTACTS"), icon: "envelope")
        themeVM.didTap { [unowned self] (model: DSActionVM) in
            self.openWebPage(url: loc("INFO_PRICING_URL") )
        }
        
        return themeVM
    }
    
    /// Open web page
    /// - Parameter url: String
    func openWebPage(url: String) {
        
        if let url = URL(string: url) {
            
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = false
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    /// Action view model
    /// - Parameters:
    ///   - title: String
    ///   - description: String?
    ///   - icon: String?
    /// - Returns: DSActionVM
    func article(title: String,
                 description: String? = nil,
                 icon: String? = nil,
                 image: String? = nil,
                 tint: UIColor? = nil) -> DSActionVM {
        
        // Text
        let text = DSTextComposer()
        text.add(type: .headlineWithSize(15), text: title)
        
        if let description = description {
            text.add(type: .subheadline, text: description)
        }
        
        // Action
        var action = text.actionViewModel()
        
        if let icon = icon {
            if let tint = tint {
                action.leftIcon(sfSymbolName: icon, tintColor: .custom(tint))
            } else {
                action.leftIcon(sfSymbolName: icon)
            }
        }
        
        if let image = image {
            if let tint = tint {
                action.leftImage(image: UIImage(named: image),
                                 style: .default, size: .size(.init(width: 24, height: 18)),
                                 contentMode: .scaleAspectFit,
                                 tintColor: .custom(tint))
            } else {
                action.leftImage(image: UIImage(named: image),
                                 style: .default,
                                 size: .size(.init(width: 24, height: 18)),
                                 contentMode: .scaleAspectFit)
            }
        }
        
        action.rightArrow()
        return action
    }
}
