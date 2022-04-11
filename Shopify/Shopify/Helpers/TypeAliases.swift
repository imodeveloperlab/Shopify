//
//  TypeAliases.swift
//  HueSDK
//
//  Created by Borinschi Ivan on 1/12/20.
//  Copyright © 2020 Imodeveloperlab. All rights reserved.
//

import Foundation

/// Is an generic type-alias which represents an closure with Error and return Void
public typealias Fail = (ShopError) -> Void

/// Is an generic type-alias which represents an closure with T and return Void
public typealias Success<T> = (T) -> Void

/// Is an generic type-alias which represents an closure with T and return Void
public typealias Done<T> = (T) -> Void

public typealias HandleDidTap = () -> Void

public typealias ProductID = String
public typealias ProductCollection = String
public typealias ProductTag = String
public typealias ProductSearch = String
public typealias ProductType = String
public typealias SortOption = String
public typealias CollectionID = String

