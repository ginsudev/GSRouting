//
//  AppRouter.swift
//
//
//  Created by Noah Little on 6/1/2024.
//

import SwiftUI

// MARK: - [Public] AppRoute

/// A type conforming to this protocol must declare the types used
/// for modes of navigation.
public protocol AppRouteDescriber {
    associatedtype Tab: TabRepresentable
    associatedtype Sheet: SheetRepresentable
    associatedtype Destination: DestinationRepresentable
}

/// A type conforming to this protocol must declare the types used for
/// rendering views related to different modes of navigation.
public protocol AppRouteDisplayer {
    associatedtype TabDisplayer: TabRouteDisplayer
    associatedtype SheetDisplayer: SheetRouteDisplayer
    associatedtype DestinationDisplayer: NavigationPathRouteDisplayer
}

// MARK: - [Public] Navigation types

/// A tab
public protocol TabRepresentable: CaseIterable, Hashable { }

/// A sheet
public protocol SheetRepresentable: Identifiable { }

/// A navigation destination
public protocol DestinationRepresentable: Hashable { }

// MARK: - [Public] Displayer

/// A view that displays the tab items displayed on the tab bar.
public protocol TabRouteDisplayer: View {
    associatedtype Tab: TabRepresentable
    var tab: Tab { get }
    init(tab: Tab)
}

/// A view renders the it's body based on the passed in `Sheet`.
public protocol SheetRouteDisplayer: View {
    associatedtype Sheet: SheetRepresentable
    var sheet: Sheet { get }
    init(sheet: Sheet)
}

/// A view renders the it's body based on the passed in `Destination`.
public protocol NavigationPathRouteDisplayer: View {
    associatedtype Destination: DestinationRepresentable
    var destination: Destination { get }
    init(destination: Destination)
}
