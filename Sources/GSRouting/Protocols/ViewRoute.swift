//
//  ViewRoute.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import SwiftUI

// MARK: - ViewRoute

/**
 A protocol defining a view that can be presented by the `AppNavigationRouter`.

 This protocol allows for the creation of presentable views with a specific body.

 - Note: Implementing types must conform to `Hashable`, `Equatable`, `Identifiable` where the identifier type `ID` is `String`.

 - Important: The associated type `Body` must conform to SwiftUI's `View` protocol.

 Usage:
 ```swift
 struct MyViewRoute: ViewRoute {

     func makeBody(context: Context) -> some View {
        switch context.presentationMode {
            case .destination:
                MyView()
                    .navigationBarTitleDisplayMode(.inline)
            default:
                 MyView()
                    .navigationBarTitleDisplayMode(.large)
                    .routable()
        }
     }
 }
 ```
 */
@_typeEraser(AnyViewRoute)
public protocol ViewRoute: Hashable, Equatable, Identifiable where ID == String {
    /// The type of view representing the body of this ViewRoute.
    associatedtype Body: View
    
    /**
     Generates the main content body of the view to be presented in a navigation context.

     - Parameters:
        - context: The context in which this view is being presented.

     - Returns: A SwiftUI `View` representing the main content of the view.
     */
    @MainActor @ViewBuilder
    func makeBody(context: Context) -> Body
    
    typealias Context = RoutableViewContext
}

// MARK: - Protocol default implementations

public extension ViewRoute {
    
    var id: ID {
        "\(type(of: self as Any))"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Configuration

///  Contextual information for a routable view within a navigation system.
///
///  - SeeAlso: ``ViewRoute``
public struct RoutableViewContext {
    /// The mode in which the view is presented.
    public let presentationMode: Self.PresentationMode
    
    /// Identification for how the view is being presented.
    public enum PresentationMode {
        case destination
        case sheet
        case fullScreenCover
    }
}
