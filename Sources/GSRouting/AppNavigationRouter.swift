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
    private var callbacks: Callbacks?
    
    internal func initialize(
        push: @escaping (AnyViewRoute) -> Void,
        pop: @escaping () -> Void,
        popToRoot: @escaping () -> Void,
        presentSheet: @escaping (AnyViewRoute) -> Void,
        presentCover: @escaping (AnyViewRoute) -> Void,
        switchToTab: @escaping (_ id: String) -> Void
    ) {
        self.callbacks = .init(
            push: push,
            pop: pop,
            popToRoot: popToRoot,
            presentSheet: presentSheet,
            presentCover: presentCover,
            switchToTab: switchToTab
        )
    }

    /// Pushes the view for the given route onto the navigation stack.
    public func push(_ view: some ViewRoute) {
        callbacks?.push(AnyViewRoute(erasing: view))
    }
    
    /// Pops the last view route from the navigation stack.
    public func pop() {
        callbacks?.pop()
    }
    
    /// Resets the navigation stack, returning to the root view.
    public func popToRoot() {
        callbacks?.popToRoot()
    }
    
    /// Presents the view for the given route in a sheet.
    public func presentSheet(_ view: some ViewRoute) {
        callbacks?.presentSheet(AnyViewRoute(erasing: view))
    }
    
    /// Presents the view for the given route in a fullScreenCover.
    public func presentCover(_ view: some ViewRoute) {
        callbacks?.presentCover(AnyViewRoute(erasing: view))
    }
    
    /// Switches to the tab with the given ID.
    public func switchTab(id: String) {
        callbacks?.switchToTab(id)
    }
    
    private struct Callbacks {
        let push: (_ view: AnyViewRoute) -> Void
        let pop: () -> Void
        let popToRoot: () -> Void
        let presentSheet: (_ view: AnyViewRoute) -> Void
        let presentCover: (_ view: AnyViewRoute) -> Void
        let switchToTab: (_ id: String) -> Void
    }
}
