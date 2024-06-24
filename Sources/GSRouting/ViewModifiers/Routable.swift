//
//  Routable.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import SwiftUI

private struct RoutableViewModifier: ViewModifier {
    
    @EnvironmentObject
    private var tabRouter: AppTabRouter
    
    @StateObject
    private var navRouter: AppNavigationRouter = .init()
    
    @State
    private var path: [AnyViewRoute] = []
    
    @State
    private var sheet: AnyViewRoute?
    
    @State
    private var fullScreenCover: AnyViewRoute?
    
    func body(content: Content) -> some View {
        NavigationStack(path: $path) {
            content
                .sheet(item: $sheet, content: sheetView)
                .fullScreenCover(item: $fullScreenCover, content: fullScreenCoverView)
                .navigationDestination(for: AnyViewRoute.self, destination: navigationDestinationView)
        }
        .onAppear {
            navRouter.initialize(
                push: { destination in
                    self.path.append(destination)
                },
                pop: {
                    _ = self.path.popLast()
                },
                popToRoot: {
                    self.path = []
                },
                presentSheet: { sheet in
                    self.sheet = sheet
                },
                presentCover: { cover in
                    self.fullScreenCover = cover
                },
                switchToTab: { id in
                    self.tabRouter.switchToTab(id: id)
                }
            )
        }
        .environmentObject(navRouter)
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

extension View {
    
    /// Marks this view as the "root view" of a new navigation stack and gives subviews the ability to
    /// control the navigation through usage of the ``Router`` propertyWrapper, or access via environment object.
    public func routable() -> some View {
        modifier(RoutableViewModifier())
    }
}
