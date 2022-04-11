//
//  ImageGallery1ViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 02.03.2021.
//

import DSKit
import UIKit

final class ImageGalleryViewController: DSViewController {
    
    init(images: [URL]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let images: [URL]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
        
        self.handleScrollViewDidScroll { [unowned self] scrollView in
            
            if scrollView.contentOffset.y < -100 {
                self.dismiss()
            }
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.update()
    }
    
    // Call every time some data have changed
    func update() {
        
        let section = gallerySection()
        show(content: header(), section)
    }
    
    @objc func openFilters() {
        self.dismiss()
    }
    
    @objc func openSort() {
        self.dismiss()
    }
}

// MARK: - Section

extension ImageGalleryViewController {
    
    // Header section
    func header() -> DSSection {
        
        // Title
        var label = DSLabelVM(.headline, text: "Images", alignment: .center)
        
        var xmark = DSImageVM(imageValue: .sfSymbol(name: "xmark.circle.fill", style: .medium))
        xmark.width = .absolute(25)
        xmark.height = .absolute(25)
        xmark.tintColor = .custom(appearance.primaryView.button.background)
        
        label.didTap { model in
            self.dismiss()
        }
        
        var colors = DSAppearance.shared.main.primaryView
        colors.button.background = UIColor.label
        
        label.supplementaryItems = [xmark.asSupplementary(position: .rightCenter, background: .clear, insets: .insets(.zero), offset: .custom(.init(x: 0, y: 0)))]
        return label.list()
    }
    
    /// Products gallery
    /// - Returns: DSSection
    func gallerySection() -> DSSection {
        
        let pictures = images.map { (url) -> DSViewModel in
            
            DSImageVM(imageUrl: url,
                      height: .absolute(UIDevice.current.contentAreaHeigh - 100),
                      displayStyle: .default,
                      contentMode: .scaleAspectFit)
        }
        
        let pageControl = DSPageControlVM(type: .viewModels(pictures), galleryType: .fullWidth)
        return pageControl.list().zeroLeftRightInset().zeroBottomInset()
    }
}
