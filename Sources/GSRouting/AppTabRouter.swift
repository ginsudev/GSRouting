//
//  AppTabRouter.swift
//  GSRouting
//
//  Created by Noah Little on 23/12/2025.
//

import Foundation

@MainActor
public final class AppTabRouter: ObservableObject {
    public let tabs: [AnyTabRoute]
    private var routerForTab: [String: WeakBox] = [:]
    
    @Published public internal(set) var selectedTab: AnyTabRoute
    
    internal init(tabs: [any TabRoute]) {
        guard let firstTab = tabs.first else { fatalError("Must have atleast 1 tab.") }
        self.tabs = tabs.map(AnyTabRoute.init(erasing:))
        self.selectedTab = .init(erasing: firstTab)
    }
    
    public func selectTab(id: String) {
        guard selectedTab.id != id, let newTab = tabs.first(where: { $0.id == id }) else { return }
        self.selectedTab = newTab
    }
    
    public func navigationRouterForTab(id: String) -> AppNavigationRouter {
        if let router = routerForTab[id]?.wrappedValue {
            return router
        } else {
            let router = AppNavigationRouter(tabRouter: self)
            routerForTab[id] = .init(wrappedValue: router)
            return router
        }
    }
    
    private final class WeakBox {
        weak var wrappedValue: AppNavigationRouter?
        init(wrappedValue: AppNavigationRouter) { self.wrappedValue = wrappedValue }
    }
}
