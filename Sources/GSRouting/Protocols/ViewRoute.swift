//
//  ViewRoute.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

/// A protocol which can be used to make a view presentable by the `AppNavigationRouter`.
public protocol ViewRoute {
    associatedtype Body: View
    
    @ViewBuilder func makeBody(configuration: RoutableViewConfiguration) -> Body
    
    typealias Configuration = RoutableViewConfiguration
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
