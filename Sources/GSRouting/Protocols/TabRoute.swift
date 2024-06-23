//
//  TabRoute.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

@_typeEraser(AnyTabRoute)
/// A protocol which can be used to render a tab.
public protocol TabRoute: Hashable, Equatable, Identifiable where ID == String {
    associatedtype TabLabel: View
    associatedtype TabContent: View
        
    @MainActor @ViewBuilder
    func makeLabel(configuration: RoutableTabConfiguration) -> TabLabel
    
    @MainActor @ViewBuilder
    func makeContent(configuration: RoutableTabConfiguration) -> TabContent
    
    typealias Configuration = RoutableTabConfiguration
}

public extension TabRoute {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

public struct RoutableTabConfiguration {
    public let isSelected: Bool
}
