//
//  RoutableTab.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

/// A protocol which can be used to render a tab.
public protocol RoutableTab {
    associatedtype TabLabel: View
    associatedtype TabContent: View
    
    var id: String { get }
    
    @ViewBuilder func makeLabel(configuration: RoutableTabConfiguration) -> TabLabel
    @ViewBuilder func makeContent(configuration: RoutableTabConfiguration) -> TabContent
    
    typealias Configuration = RoutableTabConfiguration
}

public struct RoutableTabConfiguration {
    public let isSelected: Bool
}
