//
//  TabRouter.swift
//
//
//  Created by Noah Little on 7/1/2024.
//

import SwiftUI

// MARK: - Impl

@Observable
internal final class TabRouter<AppRoutes: AppRouteDescriber> {
    fileprivate var tab: AppRoutes.Tab = Array(AppRoutes.Tab.allCases)[0]
    fileprivate init() { }
    
    internal func switchToTab(_ tab: AppRoutes.Tab) {
        self.tab = tab
    }
}

// MARK: - View

public struct RoutableTabView<
    AppRoutes: AppRouteDescriber,
    AppDisplayers: AppRouteDisplayer
>: View where AppRoutes.Tab == AppDisplayers.TabDisplayer.Tab, AppRoutes.Sheet == AppDisplayers.SheetDisplayer.Sheet, AppRoutes.Destination == AppDisplayers.DestinationDisplayer.Destination {
    
    @State
    private var tabRouter: TabRouter<AppRoutes> = .init()
    
    public init() { }
    
    public var body: some View {
        TabView(selection: $tabRouter.tab) {
            ForEach(Array(AppRoutes.Tab.allCases), id: \.self) { tab in
                AppDisplayers.TabDisplayer(tab: tab)
                    .tag(tab)
            }
        }
        .environment(tabRouter)
    }
}
