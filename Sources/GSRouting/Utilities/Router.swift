//
//  Router.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

/// A convenience propertyWrapper to access the injected `AppNavigationRouter` instance.
@propertyWrapper
public struct Router: DynamicProperty {
    
    @EnvironmentObject
    private var router: AppNavigationRouter
    
    public var wrappedValue: AppNavigationRouter { router }
    
    public init() { }
}
