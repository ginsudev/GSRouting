//
//  Routable.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

private struct RoutableNavigationStack<Content: View>: View {
    @StateObject private var navigationRouter: AppNavigationRouter
    
    private let content: Content
    
    init(tabRouter: AppTabRouter?, @ViewBuilder _ content: @escaping () -> Content) {
        self._navigationRouter = .init(wrappedValue: .init(tabRouter: tabRouter))
        self.content = content()
    }
    
    var body: some View {
        Base(navigationRouter: navigationRouter) {
            content
        }
    }
    
    fileprivate struct Base: View {
        @ObservedObject private var navigationRouter: AppNavigationRouter
        
        private let content: Content
        
        init(navigationRouter: AppNavigationRouter, @ViewBuilder _ content: @escaping () -> Content) {
            self.navigationRouter = navigationRouter
            self.content = content()
        }
        
        var body: some View {
            NavigationStack(path: $navigationRouter.path) {
                content
                    .sheet(item: $navigationRouter.sheet, content: sheetView)
                    .fullScreenCover(item: $navigationRouter.fullScreenCover, content: fullScreenCoverView)
                    .navigationDestination(for: AnyViewRoute.self, destination: navigationDestinationView)
            }
            .environmentObject(navigationRouter)
        }
        
        private func sheetView(_ sheet: AnyViewRoute) -> some View {
            sheet.makeBody(context: .init(presentationMode: .sheet))
        }
        
        private func fullScreenCoverView(_ cover: AnyViewRoute) -> some View {
            cover.makeBody(context: .init(presentationMode: .fullScreenCover))
        }
        
        private func navigationDestinationView(_ destination: AnyViewRoute) -> some View {
            destination.makeBody(context: .init(presentationMode: .destination))
        }
    }
}

private struct AppTabRouterReader<Content: View>: View {
    @Environment(\.tabRouter) private var tabRouter

    private let content: (AppTabRouter?) -> Content
    
    init(@ViewBuilder _ content: @escaping (AppTabRouter?) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(tabRouter)
    }
}

extension View {
    
    /// Marks this view as the "root view" of a new navigation stack and gives subviews the ability to
    /// control the navigation through usage of the ``Router`` propertyWrapper, or access via environment object.
    public func routable() -> some View {
        AppTabRouterReader { tabRouter in
            RoutableNavigationStack(tabRouter: tabRouter) {
                self
            }
        }
    }
    
    /// Marks this view as the "root view" of a new navigation stack with the given navigation router,
    /// and gives subviews the ability to control the navigation through usage of the ``Router`` propertyWrapper,
    /// or access via environment object.
    public func routable(_ navigationRouter: AppNavigationRouter) -> some View {
        RoutableNavigationStack.Base(navigationRouter: navigationRouter) {
            self
        }
    }
}
