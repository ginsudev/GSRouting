//
//  AppNavigationRouter.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import Foundation

/// A class to handle navigation routing operations, such as presenting sheets,
/// switching tabs, pushing onto the nav stack etc.
@MainActor public final class AppNavigationRouter: ObservableObject {
    @Published internal var path: [AnyViewRoute] = []
    @Published internal var sheet: AnyViewRoute?
    @Published internal var fullScreenCover: AnyViewRoute?
    
    private let tabRouter: AppTabRouter?
    
    internal init(tabRouter: AppTabRouter?) {
        self.tabRouter = tabRouter
    }

    /// Pushes the view for the given route onto the navigation stack.
    public func push(_ view: some ViewRoute) {
        path.append(AnyViewRoute(erasing: view))
    }
    
    /// Pops the last view route from the navigation stack.
    public func pop() {
        _ = path.popLast()
    }
    
    /// Resets the navigation stack, returning to the root view.
    public func popToRoot() {
        path = []
    }
    
    /// Presents the view for the given route in a sheet.
    public func presentSheet(_ view: some ViewRoute) {
        sheet = AnyViewRoute(erasing: view)
    }
    
    /// Presents the view for the given route in a fullScreenCover.
    public func presentCover(_ view: some ViewRoute) {
        fullScreenCover = AnyViewRoute(erasing: view)
    }
    
    // TODO: - Make this more type safe.
    /// Switches to the tab with the given ID.
    public func switchTab(id: String) {
        tabRouter?.selectTab(id: id)
    }
}
