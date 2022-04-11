//
//  DescriptionDetailsViewController.swift
//  Shopify
//  Documentation https://dskit.app/components
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import WebKit
import Cartography

final class DescriptionDetailsViewController: DSViewController {
    
    var webView = WKWebView()
    var htmlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = loc("DESCRIPTION_DETAILS")
        
        self.view.addSubview(webView)
        
        constrain(webView, view) { webView, view in
            webView.edges == view.edges
        }
        
        guard var htmlString = htmlString else {
            return
        }
        
        let css = """
            <style>
            body {
              font-family: Arial, Helvetica, sans-serif;
              padding: 50px;
              font-size: 40px;
              line-height: 1.4;
            }
            </style>
            """
        
        htmlString = "\(css)<body>\(htmlString)</body>"
        
        webView.loadHTMLString(htmlString, baseURL: URL(string: "https://dskit-commerce.myshopify.com/products/adidas-classic-backpack-legend-ink-multicolour"))
    }
}
