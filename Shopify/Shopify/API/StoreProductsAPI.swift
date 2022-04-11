//
//  Store.swift
//  Shopify
//  DSKit docs https://dskit.app/components
//  Shopify docs https://github.com/Shopify/mobile-buy-sdk-ios
//
//  Created by Borinschi Ivan on 26.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Buy

class StoreProductsAPI {
    
    let client: Graph.Client
    
    init() {
        client = GraphClient.shared.client
        client.cachePolicy = .cacheFirst(expireIn: 60)
    }
    
    /// Get products
    /// - Parameters:
    ///   - tag: Product tag
    ///   - first: Count
    ///   - success: Success<[Storefront.Product]>
    ///   - fail: Fail
    func getProducts(count: Int32,
                     filter: ProductFilter? = nil,
                     success: @escaping Success<[Storefront.Product]>,
                     fail: @escaping Fail) {
        
        let query = Storefront.buildQuery { $0
            
            .products(first: count, sortKey: filter?.sortKey(), query: filter?.queryString()) { $0
                .edges { $0
                    .node { $0
                        .id()
                        .title()
                        .description()
                        .images(first: 1) { $0
                            .edges { $0
                                .node { $0
                                    .id()
                                    .transformedSrc()
                                }
                            }
                        }
                        .variants(first: 1) { $0
                            .edges { $0
                                .node { $0
                                    .id()
                                    .compareAtPriceV2({ $0
                                        .amount()
                                        .currencyCode()
                                    })
                                    .priceV2({ $0
                                        .amount()
                                        .currencyCode()
                                    })
                                    .title()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            
            if let products = response?.products.edges.map({ $0.node }) {
                success(products)
            } else {                
                fail(.init(code: .GraphQueryError(error)))
            }
            
        }
        task.resume()
    }
    
    func getProduct(productID: ProductID,
                    selectedOptions: [Storefront.SelectedOptionInput],
                    success: @escaping Success<(product: Storefront.Product, images: [Storefront.Image], variants: [Storefront.ProductVariant])>,
                    fail: @escaping Fail) {
        
        let id = GraphQL.ID(rawValue: productID)
        
        let query = Storefront.buildQuery { $0
            .node(id: id) { $0
                .onProduct { $0
                    .id()
                    .title()
                    .description()
                    .descriptionHtml()
                    .productType()
                    .publishedAt()
                    .updatedAt()
                    .variantBySelectedOptions(selectedOptions: selectedOptions, { $0
                        .id()
                        .title()
                        .availableForSale()
                        .quantityAvailable()
                        .currentlyNotInStock()
                        .requiresShipping()
                        .selectedOptions({ $0
                            .name()
                            .value()
                        })
                        .compareAtPriceV2({ $0
                            .amount()
                            .currencyCode()
                        })
                        .priceV2({ $0
                            .amount()
                            .currencyCode()
                        })
                    })
                    .options({ $0
                        .id()
                        .name()
                        .values()
                    })
                    .images(first: 100) { $0
                        .edges { $0
                            .node { $0
                                .id()
                                .transformedSrc()
                                .originalSrc()
                                .height()
                                .width()
                            }
                        }
                    }
                    .variants(first: 100) { $0
                        .edges { $0
                            .node { $0
                                .id()
                                .title()
                                .requiresShipping()
                                .availableForSale()
                                .quantityAvailable()
                                .currentlyNotInStock()
                                .selectedOptions({ $0
                                    .name()
                                    .value()
                                })
                                .compareAtPriceV2({ $0
                                    .amount()
                                    .currencyCode()
                                })
                                .priceV2({ $0
                                    .amount()
                                    .currencyCode()
                                })
                            }
                        }
                    }
                }
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            
            guard let product = response?.node as? Storefront.Product else {
                fail(.init(code: .UNKNOWN_ERROR))
                return
            }
            
            let variants = product.variants.edges.map { $0.node }
            let images = product.images.edges.map { $0.node }
            success((product: product, images: images, variants: variants))
        }
        
        task.resume()
    }
    
    func getProductSortKeys(success: @escaping Success<[Storefront.ProductSortKeys]>, fail: @escaping Fail) {
        
        success([Storefront.ProductSortKeys.bestSelling,
                 Storefront.ProductSortKeys.createdAt,
                 Storefront.ProductSortKeys.price,
                 Storefront.ProductSortKeys.productType,
                 Storefront.ProductSortKeys.relevance])
    }
}
