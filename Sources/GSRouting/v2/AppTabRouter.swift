//
//  AppTabRouter.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation

internal final class AppTabRouter: ObservableObject {
    
    @Published 
    var selectedTab: Hashed<any RoutableTab>
    
    let tabs: [Hashed<any RoutableTab>]
    
    init(tabs: [any RoutableTab]) {
        if tabs.isEmpty {
            fatalError("Must have at least 1 tab.")
        }
        
        let hashedTabs = tabs.map(Hashed.init)
        self.selectedTab = hashedTabs[0]
        self.tabs = hashedTabs
    }
    
    func switchToTab(id: String) {
        guard selectedTab.wrappedValue.id != id else {
            return
        }
        
        for tab in tabs where tab.wrappedValue.id == id {
            self.selectedTab = tab
            break
        }
    }
}
