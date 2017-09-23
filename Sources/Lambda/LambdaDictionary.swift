//
//  LambdaDictionary.swift
//  Lambda
//
//  Created by Bernardo Breder on 10/12/16.
//
//

import Foundation

extension Dictionary {
    
    public var lambda: LambdaDictionary<Key, Value> {
        return LambdaDictionary<Key, Value>(self)
    }
    
}

open class LambdaDictionary<K: Hashable,V>: Lambda<[K:V]> {

    public override init(_ value: [K:V]) {
        super.init(value)
    }
    
    public subscript(key: K) -> NullableLambda<V> {
        get {
            return NullableLambda<V>(value[key])
        }
    }

    @discardableResult
    public func put(key: K, value: V) -> Self {
        self.value[key] = value
        return self
    }
    
    @discardableResult
    public func put(_ dic: [K:V]) -> Self {
        for (key, value) in dic {
            self.value[key] = value
        }
        return self
    }
    
    public func has(_ key: K) -> Bool {
        return self.value[key] != nil
    }
    
    public var count: Int {
        return value.count
    }
    
}

extension LambdaDictionary {
    
    public func mapValue<T>(_ callback: (V) throws -> T) rethrows -> LambdaDictionary<K,T> {
        let array: [K:V] = self.value
        var result: [K:T] = [K:T]()
        for (k,v) in array {
            result[k] = try callback(v)
        }
        return LambdaDictionary<K,T>(result)
    }

}
