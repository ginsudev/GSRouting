//
//  AppTabRouter.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation

internal final class AppTabRouter: ObservableObject {
    
    @Published 
    var selectedTab: AnyTabRoute
    
    let tabs: [AnyTabRoute]
    
    init(tabs: [any TabRoute]) {
        if tabs.isEmpty { fatalError("Must have at least 1 tab.") }
        
        let hashedTabs = tabs.map(AnyTabRoute.init)
        self.selectedTab = hashedTabs[0]
        self.tabs = hashedTabs
    }
    
    func switchToTab(id: String) {
        guard selectedTab.id != id else {
            return
        }
        
        if let tab = tabs.first(where: { $0.id == id }) {
            self.selectedTab = tab
        }
    }
}
