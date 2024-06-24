//
//  TabRoute.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

// MARK: - TabRoute

/**
 A protocol defining the structure of a tab in a tab-based navigation system.

 This protocol allows for the creation of customizable tabs with a specific label and content.

 - Note: Implementing types must conform to `Hashable`, `Equatable`, `Identifiable` where the identifier type `ID` is `String`.

 - Important: The associated types `TabLabel` and `TabContent` must conform to SwiftUI's `View` protocol.
 
 - Important: It is recommended to add the `.routable()` modifier to the view returned in `makeContent`,
 so that subviews can access the injected @``Router``.

 Usage:
 ```swift
 struct HomeTab: TabRoute {

     func makeLabel(context: Context) -> some View {
         Label("Home", image: context.isSelected ? "house.fill" : "house")
     }

     func makeContent(context: Context) -> some View {
         HomeScene().routable()
     }
 }
 ```
 */
@_typeEraser(AnyTabRoute)
public protocol TabRoute: Hashable, Equatable, Identifiable where ID == String {
    /// The type of view representing the label of this TabRoute.
    associatedtype TabLabel: View
    /// The type of view representing the content of this TabRoute.
    associatedtype TabContent: View
    
    /**
     The label view for the tab, based on the provided context.

     - Parameters:
        - context: The context in which the tab label is being created.
    */
    @MainActor @ViewBuilder
    func makeLabel(context: Context) -> TabLabel
    
    /**
     The content view for the tab, based on the provided context.

     - Parameters:
        - context: The context in which the tab content is being created.
    */
    @MainActor @ViewBuilder
    func makeContent(context: Context) -> TabContent
    
    typealias Context = RoutableTabContext
}

// MARK: - Protocol default implementations

public extension TabRoute {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Context

/**
 Contextual information for a routable tab within a tab-based navigation system.

 - SeeAlso: ``TabRoute``
 */
public struct RoutableTabContext {
    /// Whether the tab is currently selected.
    public let isSelected: Bool
}
