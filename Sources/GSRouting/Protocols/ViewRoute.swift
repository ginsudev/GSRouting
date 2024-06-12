//
//  ViewRoute.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

@_typeEraser(AnyViewRoute)
/// A protocol which can be used to make a view presentable by the `AppNavigationRouter`.
public protocol ViewRoute: Hashable, Equatable, Identifiable where ID == String {
    associatedtype Body: View
    
    @ViewBuilder func makeBody(configuration: RoutableViewConfiguration) -> Body
    
    typealias Configuration = RoutableViewConfiguration
}

public extension ViewRoute {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration to customise how the view will look/behave under different scenarios.
public struct RoutableViewConfiguration {
    public let presentationMode: Self.PresentationMode
    
    /// Identification for how the view is being presented.
    public enum PresentationMode {
        case destination
        case sheet
        case fullScreenCover
    }
}
