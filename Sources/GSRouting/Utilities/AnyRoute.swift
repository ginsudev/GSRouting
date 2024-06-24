//
//  AnyRoute.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation
import SwiftUI

/// A type-erased ViewRoute.
public struct AnyViewRoute: ViewRoute {
    public typealias Body = AnyView
        
    private let _route: any ViewRoute
    
    public var id: ID { _route.id }
    
    public init(erasing wrappedValue: any ViewRoute) {
        self._route = wrappedValue
    }
    
    public init(erasing wrappedValue: some ViewRoute) {
        self._route = wrappedValue
    }
    
    public func makeBody(context: Context) -> Self.Body {
        AnyView(_route.makeBody(context: context))
    }
}

/// A type-erased TabRoute.
public struct AnyTabRoute: TabRoute {
    public typealias TabLabel = AnyView
    public typealias TabContent = AnyView
        
    private let _route: any TabRoute
    
    public var id: ID { _route.id }
    
    public init(erasing wrappedValue: any TabRoute) {
        self._route = wrappedValue
    }
    
    public init(erasing wrappedValue: some TabRoute) {
        self._route = wrappedValue
    }
    
    public func makeLabel(context: Context) -> Self.TabLabel {
        AnyView(_route.makeLabel(context: context))
    }
    
    public func makeContent(context: Context) -> Self.TabContent {
        AnyView(_route.makeContent(context: context))
    }
}
