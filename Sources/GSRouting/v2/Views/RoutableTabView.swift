//
//  RoutableTabView.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

public struct RoutableTabView: View {
    
    @StateObject
    private var tabRouter: AppTabRouter
    
    public init(tabs: [any RoutableTab]) {
        self._tabRouter = .init(wrappedValue: .init(tabs: tabs))
    }
    
    public var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            ForEach(tabRouter.tabs, content: tabItem(for:))
        }
        .environmentObject(tabRouter)
    }
    
    private func tabItem(for tab: Hashed<any RoutableTab>) -> some View {
        contentView(tab: tab).tabItem {
            labelView(tab: tab)
        }
    }
    
    private func labelView(tab: Hashed<any RoutableTab>) -> some View {
        AnyView(tab.wrappedValue.makeContent(configuration: makeConfiguration(tab: tab)))
    }
    
    private func contentView(tab: Hashed<any RoutableTab>) -> some View {
        AnyView(tab.wrappedValue.makeLabel(configuration: makeConfiguration(tab: tab)))
    }
    
    private func makeConfiguration(tab: Hashed<any RoutableTab>) -> RoutableTab.Configuration {
        .init(isSelected: tabRouter.selectedTab == tab)
    }
}

#Preview {
    RoutableTabView(tabs: [])
}
