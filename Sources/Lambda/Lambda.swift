//
//  Lambda.swift
//  Lambda
//
//  Created by Bernardo Breder on 05/12/16.
//  Copyright © 2016 Breder Company. All rights reserved.
//

import Foundation

open class Lambda<E> {
    
    public internal(set) var value: E
    
    public init(_ value: E) {
        self.value = value
    }
    
    public var get: E {
        return value
    }
    
}

extension Lambda {
    
    public func empty<T>(_ function: () throws -> T) rethrows -> Lambda<T> {
        return Lambda<T>(try function())
    }
    
}

extension Lambda {
    
    public func filter(_ function: (E) throws -> Bool) rethrows -> NullableLambda<E> {
        if try !function(value) { return NullableLambda<E>(nil, nil) }
        return NullableLambda<E>(value)
    }
    
}

extension Lambda {
    
    public func map<T>(_ function: (E) throws -> T) rethrows -> Lambda<T> {
        return Lambda<T>(try function(value))
    }
    
    public func map<T>(_ function: (E) throws -> T?) rethrows -> NullableLambda<T> {
        return NullableLambda<T>(try function(value))
    }
    
    public func map<T>(_ type: T.Type) -> NullableLambda<T> {
        guard let cast = value as? T else { return NullableLambda<T>(nil, LambdaError.cast) }
        return NullableLambda<T>(cast)
    }
    
}

extension Lambda where E: CustomStringConvertible {
    
    public var description: String {
        return value.description
    }
    
}

extension Lambda where E: Equatable {
    
    public static func ==(lhs: Lambda<E>, rhs: Lambda<E>) -> Bool {
        return lhs.value == rhs.value
    }
    
    public static func !=(lhs: Lambda<E>, rhs: Lambda<E>) -> Bool {
        return lhs.value != rhs.value
    }
    
}

extension NSObject {
    
    public func change<T>(_ f: (NSObjectProtocol) throws -> T) rethrows -> T {
        return try f(self)
    }
    
}

public enum LambdaError: Error {
    case nullValue
    case cast
}
