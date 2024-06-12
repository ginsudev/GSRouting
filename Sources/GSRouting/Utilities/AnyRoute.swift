//
//  AnyRoute.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation
import SwiftUI

public struct AnyViewRoute: ViewRoute {
    public typealias Body = AnyView
        
    private let _route: any ViewRoute
    
    public var id: String { _route.id }
    
    public init(erasing wrappedValue: any ViewRoute) {
        self._route = wrappedValue
    }
    
    public init(erasing wrappedValue: some ViewRoute) {
        self._route = wrappedValue
    }
    
    public func makeBody(configuration: RoutableViewConfiguration) -> Self.Body {
        AnyView(_route.makeBody(configuration: configuration))
    }
}

public struct AnyTabRoute: TabRoute {
    public typealias TabLabel = AnyView
    public typealias TabContent = AnyView
        
    private let _route: any TabRoute
    
    public var id: String { _route.id }
    
    public init(erasing wrappedValue: any TabRoute) {
        self._route = wrappedValue
    }
    
    public init(erasing wrappedValue: some TabRoute) {
        self._route = wrappedValue
    }
    
    public func makeLabel(configuration: RoutableTabConfiguration) -> Self.TabLabel {
        AnyView(_route.makeLabel(configuration: configuration))
    }
    
    public func makeContent(configuration: RoutableTabConfiguration) -> Self.TabContent {
        AnyView(_route.makeContent(configuration: configuration))
    }
}
