//
//  Router.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

@propertyWrapper
public struct Router: DynamicProperty {
    
    @EnvironmentObject
    private var router: AppNavigationRouter
    
    public var wrappedValue: AppNavigationRouter {
        router
    }
    
    public init() { }
}
