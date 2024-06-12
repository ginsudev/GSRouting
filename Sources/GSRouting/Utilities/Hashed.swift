//
//  Hashed.swift
//
//
//  Created by Noah Little on 12/6/2024.
//

import Foundation

internal struct Hashed<T>: Hashable, Identifiable, Equatable {
    private(set) var wrappedValue: T
    
    let id: UUID
    
    init(_ wrappedValue: T) {
        self.wrappedValue = wrappedValue
        self.id = .init()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}
