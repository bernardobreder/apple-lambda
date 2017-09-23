//
//  NullableLambda.swift
//  Lambda
//
//  Created by Bernardo Breder on 09/12/16.
//
//

import Foundation

open class NullableLambda<E> {
    
    public internal(set) var value: E?
    
    public internal(set) var error: Error?
    
    public init(_ value: E? = nil, _ error: Error? = nil) {
        self.value = value
        self.error = error
    }
    
    public init(_ runnable: () throws -> E?) {
        do {
            self.value = try runnable()
            self.error = nil
        } catch let e {
            self.value = nil
            self.error = e
        }
    }
    // Retirar para que seja usado o campo value ao invés de nullable
    public var nullable: E? {
        return value
    }
    
}

extension NullableLambda {
    
    public var empty: Bool {
        return value == nil
    }
    
    public var present: Bool {
        return value != nil
    }
    
}

extension NullableLambda {
    
    public func orElse(_ new: E) -> E {
        if let value = self.value { return value }
        return new
    }
    
    public func orElse(_ function: () throws -> E) rethrows -> E {
        if let value = self.value { return value }
        return try function()
    }
    
    public func orThrow(_ error: Error) throws -> E {
        guard let value = self.value else { throw error }
        return value
    }
    
    public func get() throws -> E {
        guard let value = self.value else { throw LambdaError.nullValue }
        return value
    }
    
}

extension NullableLambda {
    
    public func filter(_ function: (E) throws -> Bool) rethrows -> Self {
        guard let value = self.value else { return self }
        if try !function(value) { self.value = nil }
        return self
    }
    
}

extension NullableLambda {
    
    public func map<T>(_ function: (E) throws -> T?) rethrows -> NullableLambda<T> {
        guard let value = self.value else { return NullableLambda<T>(nil, self.error) }
        return NullableLambda<T>(try function(value))
    }
    
}


extension NullableLambda {
    
    public func map<T>(_ type: T.Type) -> NullableLambda<T> {
        guard let value = self.value else { return NullableLambda<T>(nil, self.error) }
        guard let cast = value as? T else { return NullableLambda<T>(nil, LambdaError.cast) }
        return NullableLambda<T>(cast)
    }
    
}

extension NullableLambda {
    //TODO Trocar para map
    public func empty<T>(_ function: () throws -> T) rethrows -> Lambda<T> {
        return Lambda<T>(try function())
    }
    
    public func notnull() throws -> Lambda<E> {
        if let error = self.error { throw error }
        guard let value = self.value else { throw LambdaError.nullValue }
        return Lambda<E>(value)
    }
    
}

extension NullableLambda where E: CustomStringConvertible {
    
    public var description: String {
        if let desc = value as? CustomStringConvertible {
            return desc.description
        }
        return value == nil ? "nil" : value.debugDescription
    }
    
}

extension NullableLambda where E: Equatable {
    
    public static func ==(lhs: NullableLambda<E>, rhs: NullableLambda<E>) -> Bool {
        switch (lhs.value, rhs.value) {
        case (nil, nil):
            return true
        case let (l?, r?):
            return l == r
        default:
            return false
        }
    }
    
    public static func !=(lhs: NullableLambda<E>, rhs: NullableLambda<E>) -> Bool {
        switch (lhs.value, rhs.value) {
        case (nil, nil):
            return false
        case let (l?, r?):
            return l != r
        default:
            return true
        }
    }
    
}

extension NullableLambda {
    
    public func equal(_ other: NullableLambda<E>, compare: (E, E) -> Bool) -> Bool {
        switch (value, other.value) {
        case (nil, nil):
            return true
        case let (l?, r?):
            return compare(l, r)
        default:
            return false
        }
    }
    
}
