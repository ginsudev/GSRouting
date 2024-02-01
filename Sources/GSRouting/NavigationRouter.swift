//
//  NavigationRouter.swift
//  
//
//  Created by Noah Little on 7/1/2024.
//

import SwiftUI

// MARK: - Impl

/// A class that can be injected into SwiftUI's environment and exposes functions related to app navigation.
@Observable
open class NavigationRouter<AppRoutes: AppRouteDescriber> {
    fileprivate var sheet: AppRoutes.Sheet?
    fileprivate var fullScreenCover: AppRoutes.Sheet?
    fileprivate var destination: [AppRoutes.Destination] = []
    fileprivate var tabRouter: TabRouter<AppRoutes>?
    
    public required init() { }
    
    fileprivate func connectTabRouter(_ tabRouter: TabRouter<AppRoutes>) {
        self.tabRouter = tabRouter
    }

    /// Switches to the provided tab.
    open func switchToTab(_ tab: AppRoutes.Tab) {
        self.tabRouter?.switchToTab(tab)
    }
    
    /// Presents a sheet.
    open func presentSheet(_ sheet: AppRoutes.Sheet) {
        self.sheet = sheet
    }
    
    /// Presents a full screen cover.
    open func presentFullScreenCover(_ cover: AppRoutes.Sheet) {
        self.fullScreenCover = cover
    }
    
    /// Pushes a view onto the navigation stack.
    open func push(_ destination: AppRoutes.Destination) {
        self.destination.append(destination)
    }
    
    /// Pops a view from the navigation stack.
    open func pop() {
        _ = self.destination.popLast()
    }
    
    /// Pops all views from the navigation stack and returns to the root view for this router.
    open func popToRoot() {
        self.destination = []
    }
}

// MARK: - View modifier

/// Wraps the content in a NavigationStack and adds sheet, cover, destination handling.
private struct WithNavigationRoutingViewModifier<
    AppRoutes: AppRouteDescriber,
    AppDisplayers: AppRouteDisplayer
>: ViewModifier where AppRoutes.Tab == AppDisplayers.TabDisplayer.Tab, AppRoutes.Sheet == AppDisplayers.SheetDisplayer.Sheet, AppRoutes.Destination == AppDisplayers.DestinationDisplayer.Destination {
    
    @Environment(TabRouter<AppRoutes>.self)
    private var tabRouter
    
    @State
    private var navigationRouter: NavigationRouter<AppRoutes>
    
    init(_ navigationRouterType: NavigationRouter<AppRoutes>.Type) {
        _navigationRouter = .init(wrappedValue: navigationRouterType.init())
    }
    
    func body(content: Content) -> some View {
        NavigationStack(path: $navigationRouter.destination) {
            content
                .sheet(
                    item: $navigationRouter.sheet,
                    content: AppDisplayers.SheetDisplayer.init
                )
                .fullScreenCover(
                    item: $navigationRouter.fullScreenCover,
                    content: AppDisplayers.SheetDisplayer.init
                )
                .navigationDestination(
                    for: AppRoutes.Destination.self,
                    destination: AppDisplayers.DestinationDisplayer.init
                )
        }
        .onAppear {
            navigationRouter.connectTabRouter(tabRouter)
        }
        .environment(navigationRouter)
    }
}

// MARK: - View extension

public extension View {
    
    /// Registers this point in the view hierachy as the root of a navigation router.
    /// This modifier wraps the attached view in a `NavigationStack`, and adds
    /// sheet, cover and destination handling.
    func withNavigationRouting<
        AppRoutes: AppRouteDescriber,
        AppDisplayers: AppRouteDisplayer
    >(
        routes: AppRoutes.Type,
        displayers: AppDisplayers.Type
    ) -> some View where AppRoutes.Tab == AppDisplayers.TabDisplayer.Tab, AppRoutes.Sheet == AppDisplayers.SheetDisplayer.Sheet, AppRoutes.Destination == AppDisplayers.DestinationDisplayer.Destination {
        modifier(
            WithNavigationRoutingViewModifier<AppRoutes, AppDisplayers>(NavigationRouter<AppRoutes>.self)
        )
    }
    
    /// Registers this point in the view hierachy as the root of a navigation router.
    /// This modifier wraps the attached view in a `NavigationStack`, and adds
    /// sheet, cover and destination handling.
    ///
    /// This variation allows using a custom NavigationRouter subclass.
    func withNavigationRouting<
        AppRoutes: AppRouteDescriber,
        AppDisplayers: AppRouteDisplayer
    >(
        router: NavigationRouter<AppRoutes>.Type,
        displayers: AppDisplayers.Type
    ) -> some View where AppRoutes.Tab == AppDisplayers.TabDisplayer.Tab, AppRoutes.Sheet == AppDisplayers.SheetDisplayer.Sheet, AppRoutes.Destination == AppDisplayers.DestinationDisplayer.Destination {
        modifier(
            WithNavigationRoutingViewModifier<AppRoutes, AppDisplayers>(router)
        )
    }
}
