//
//  AppNavigationRouter.swift
//
//
//  Created by Noah Little on 11/6/2024.
//

import Foundation

public final class AppNavigationRouter: ObservableObject {
    private var callbacks: Callbacks?
    
    internal func initialize(
        push: @escaping (Hashed<any RoutableView>) -> Void,
        pop: @escaping () -> Void,
        popToRoot: @escaping () -> Void,
        presentSheet: @escaping (Hashed<any RoutableView>) -> Void,
        presentCover: @escaping (Hashed<any RoutableView>) -> Void,
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

    public func push(_ view: any RoutableView) {
        callbacks?.push(.init(view))
    }
    
    public func pop() {
        callbacks?.pop()
    }
    
    public func popToRoot() {
        callbacks?.popToRoot()
    }
    
    public func presentSheet(_ view: any RoutableView) {
        callbacks?.presentSheet(.init(view))
    }
    
    public func presentCover(_ view: any RoutableView) {
        callbacks?.presentCover(.init(view))
    }
    
    public func switchTab(id: String) {
        callbacks?.switchToTab(id)
    }
    
    private struct Callbacks {
        let push: (_ view: Hashed<any RoutableView>) -> Void
        let pop: () -> Void
        let popToRoot: () -> Void
        let presentSheet: (_ view: Hashed<any RoutableView>) -> Void
        let presentCover: (_ view: Hashed<any RoutableView>) -> Void
        let switchToTab: (_ id: String) -> Void
    }
}
