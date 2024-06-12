//
//  AnyRoute.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation
import SwiftUI

internal struct AnyViewRoute: ViewRoute, Identifiable, Hashable {
    typealias Body = AnyView
    
    let id: UUID
    
    private let _route: any ViewRoute
    
    init(erasing wrappedValue: any ViewRoute) {
        self._route = wrappedValue
        self.id = UUID()
    }
    
    func makeBody(configuration: RoutableViewConfiguration) -> Self.Body {
        AnyView(_route.makeBody(configuration: configuration))
    }
    
    static func == (lhs: AnyViewRoute, rhs: AnyViewRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

internal struct AnyTabRoute: TabRoute, Identifiable, Hashable {
    typealias TabLabel = AnyView
    typealias TabContent = AnyView
    
    let id: String
    
    private let _route: any TabRoute
    
    init(erasing wrappedValue: any TabRoute) {
        self._route = wrappedValue
        self.id = wrappedValue.id
    }
    
    func makeLabel(configuration: RoutableTabConfiguration) -> Self.TabLabel {
        AnyView(_route.makeLabel(configuration: configuration))
    }
    
    func makeContent(configuration: RoutableTabConfiguration) -> Self.TabContent {
        AnyView(_route.makeContent(configuration: configuration))
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AnyTabRoute, rhs: AnyTabRoute) -> Bool {
        lhs.id == rhs.id
    }
}
