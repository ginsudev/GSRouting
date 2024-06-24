//
//  RoutableTabView.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

/// A wrapper over `TabView` which adds programmatic routing capabilities to the app.
///
/// To get started, use the `init(tabs: [any RoutableTab])` initialiser of `RoutableTabView`
/// on the root view of the app where a `TabView` would normally go.
///
/// ```swift
///
/// var body: some View {
///     RoutableTabView(tabs: [HomeTabRoute(), SearchTabRoute()])
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
    
    @StateObject
    private var tabRouter: AppTabRouter
    
    public init(tabs: [any TabRoute]) {
        self._tabRouter = .init(wrappedValue: .init(tabs: tabs))
    }
    
    public var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            ForEach(tabRouter.tabs) { tab in
                contentView(tab: tab)
                    .tabItem { labelView(tab: tab) }
                    .tag(tab)
            }
        }
        .environmentObject(tabRouter)
    }
    
    private func labelView(tab: AnyTabRoute) -> some View {
        tab.makeLabel(context: makeContext(tab: tab))
    }
    
    private func contentView(tab: AnyTabRoute) -> some View {
        tab.makeContent(context: makeContext(tab: tab))
    }
    
    private func makeContext(tab: AnyTabRoute) -> TabRoute.Context {
        .init(isSelected: tabRouter.selectedTab == tab)
    }
}
