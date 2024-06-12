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
    private var path: [Hashed<any RoutableView>] = []
    
    @State
    private var sheet: Hashed<any RoutableView>?
    
    @State
    private var fullScreenCover: Hashed<any RoutableView>?
    
    func body(content: Content) -> some View {
        NavigationStack(path: $path) {
            content
                .sheet(item: $sheet, content: sheetView)
                .fullScreenCover(item: $fullScreenCover, content: fullScreenCoverView)
                .navigationDestination(for: Hashed<any RoutableView>.self, destination: navigationDestinationView)
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
    
    private func sheetView(_ sheet: Hashed<any RoutableView>) -> some View {
        AnyView(sheet.wrappedValue.makeBody(configuration: .init(presentationMode: .sheet)))
    }
    
    private func fullScreenCoverView(_ cover: Hashed<any RoutableView>) -> some View {
        AnyView(cover.wrappedValue.makeBody(configuration: .init(presentationMode: .fullScreenCover)))
    }
    
    private func navigationDestinationView(_ destination: Hashed<any RoutableView>) -> some View {
        AnyView(destination.wrappedValue.makeBody(configuration: .init(presentationMode: .destination)))
    }
}

extension View {
    
    public func routable() -> some View {
        modifier(RoutableViewModifier())
    }
}
