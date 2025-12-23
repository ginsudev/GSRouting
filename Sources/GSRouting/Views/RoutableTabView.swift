//
//  RoutableTabView.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

/// A wrapper over `TabView` which adds programmatic routing capabilities to the app.
///
/// To get started, use the `init(appRouter: AppRouter, tabs: [any RoutableTab])` initialiser of `RoutableTabView`
/// on the root view of the app where a `TabView` would normally go. An instance of `appRouter` can be obtained from ``AppRouterView``
///
/// ```swift
///
/// var body: some View {
///     AppRouterView(tabs: [HomeTabRoute(), SearchTabRoute()]) { tabRouter in
///         RoutableTabView(tabRouter: tabRouter)
///     }
/// }
///
/// ```
///
/// Next, in the subviews make use of the `.routable()` view modifier. It is recommended to use `.routable()`
/// in the `makeContent` function of your `RoutableTab` objects.
///
/// Finally, access the router object from your subviews to programmatically control the navigation stack,
/// present sheets, covers and switch tabs. Example:
///
/// ```swift
///
/// struct HomeScene: View {
///     @Router private var router
///
///     var body: some View {
///         Button("Switch tab") {
///             router.switchTab(id: "search")
///         }
///
///         Button("Present sheet") {
///             router.presentSheet(.aboutMe)
///         }
///     }
/// }
///
/// ```
public struct RoutableTabView: View {
    @ObservedObject private var tabRouter: AppTabRouter
    
    public init(tabRouter: AppTabRouter) {
        self.tabRouter = tabRouter
    }
    
    public var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            ForEach(tabRouter.tabs) { tab in
                contentView(tab: tab)
                    .tabItem { labelView(tab: tab) }
                    .tag(tab)
            }
        }
    }
    
    private func labelView(tab: AnyTabRoute) -> some View {
        tab.makeLabel(context: makeContext(tab: tab))
    }
    
    private func contentView(tab: AnyTabRoute) -> some View {
        tab.makeContent(context: makeContext(tab: tab))
    }
    
    private func makeContext(tab: AnyTabRoute) -> TabRoute.Context {
        .init(isSelected: tabRouter.selectedTab.id == tab.id, router: tabRouter.navigationRouterForTab(id: tab.id))
    }
}
