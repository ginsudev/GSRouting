//
//  AppRouterView.swift
//  GSRouting
//
//  Created by Noah Little on 23/12/2025.
//

import SwiftUI

public struct AppRouterView<Content: View>: View {
    @StateObject private var viewModel: ViewModel
        
    public init(tabs: [any TabRoute], @ViewBuilder content: @escaping (_ tabRouter: AppTabRouter) -> Content) {
        self._viewModel = .init(wrappedValue: .init(renderConfig: .tabView(.init(tabs: tabs, content: content))))
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self._viewModel = .init(wrappedValue: .init(renderConfig: .singlePage(.init(content: content))))
    }
    
    public var body: some View {
        switch viewModel.renderConfig {
        case let .singlePage(config):
            config.render()
        case let .tabView(config):
            config.render()
        }
    }
    
    private enum RenderConfig {
        case singlePage(SinglePageRenderConfig)
        case tabView(TabViewRenderConfig)
        
        @MainActor
        struct TabViewRenderConfig {
            private let tabRouter: AppTabRouter
            private let content: (_ tabRouter: AppTabRouter) -> Content
            
            init(tabs: [any TabRoute], @ViewBuilder content: @escaping (_ tabRouter: AppTabRouter) -> Content) {
                self.tabRouter = AppTabRouter(tabs: tabs)
                self.content = content
            }
            
            func render() -> some View {
                content(tabRouter)
                    .environment(\.tabRouter, tabRouter)
            }
        }
        
        @MainActor
        struct SinglePageRenderConfig {
            private let content: () -> Content
            
            init(content: @escaping () -> Content) {
                self.content = content
            }

            func render() -> some View {
                content()
            }
        }
    }
    
    @MainActor
    private final class ViewModel: ObservableObject {
        let renderConfig: RenderConfig
        
        init(renderConfig: RenderConfig) {
            self.renderConfig = renderConfig
        }
    }
}
