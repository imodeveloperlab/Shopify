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

class StoreCollectionsAPI {
    
    let client: Graph.Client
    
    init() {
        client = GraphClient.shared.client
        client.cachePolicy = .cacheFirst(expireIn: 60)
    }
    
    /// Get collections
    /// - Parameters:
    ///   - first: Count
    ///   - success: Success<[Storefront.Collection]>
    ///   - fail: Fail
    func getCollections(first: Int32, success: @escaping Success<[Storefront.Collection]>, fail: @escaping Fail) {
        
        let query = Storefront.buildQuery { $0
            .collections(first: first) { $0
                .edges { $0
                    .node { $0
                        .id()
                        .title()
                        .description()
                        .image { $0
                            .originalSrc()
                        }
                    }
                }
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            
            if let collections  = response?.collections.edges.map({ $0.node }) {
                success(collections)
            } else {
                fail(.init(code: .UNKNOWN_ERROR))
            }
        }
        task.resume()
    }
    
    /// Get collection and products
    /// - Parameters:
    ///   - first: Count
    ///   - success: Success<[Storefront.Collection]>
    ///   - fail: Fail
    func getCollectionAndProducts(collectionID: CollectionID,
                                  success: @escaping Success<(collection: Storefront.Collection, products: [Storefront.Product])>,
                                  fail: @escaping Fail) {
        
        let id = GraphQL.ID(rawValue: collectionID)
        
        let query = Storefront.buildQuery { $0
            .node(id: id) { $0
                .onCollection { $0
                    .id()
                    .title()
                    .description()
                    .image { $0
                        .originalSrc()
                    }
                    .products(first: 100) { $0
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
            }
        }
        
        let task = client.queryGraphWith(query) { response, error in
            
            if let collection = response?.node as? Storefront.Collection {
                let products = collection.products.edges.map({ $0.node })
                success((collection: collection, products: products))
            } else {
                fail(.init(code: .UNKNOWN_ERROR))
            }
        }
        task.resume()
    }
}
