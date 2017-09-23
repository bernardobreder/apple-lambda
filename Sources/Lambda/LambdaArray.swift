//
//  LambdaArray.swift
//  Lambda
//
//  Created by Bernardo Breder on 05/12/16.
//  Copyright © 2016 Breder Company. All rights reserved.
//

import Foundation

extension Array {
    
    public var lambda: LambdaArray<Element> {
        return LambdaArray<Element>(self)
    }
    
}

open class LambdaArray<E> {
    
    let this: Lambda<[E]>
    
    public var value: [E] {
        return this.value
    }
    
    public init(_ values: [E]) {
        this = Lambda<[E]>(values)
    }
    
    @discardableResult
    public func append(_ elem: E) -> Self {
        this.value.append(elem)
        return self
    }
    
    public func filter(_ function: (E) throws -> Bool) rethrows -> LambdaArray<E> {
        let value = this.value
        var array: [E] = []
        for v: E in value {
            if try function(v) {
                array.append(v)
            }
        }
        return array.lambda
    }
    
    public var first: NullableLambda<E> {
        let value = this.value
        guard value.count > 0 else { return NullableLambda<E>(nil) }
        return NullableLambda<E>(value[0])
    }
    
    public var last: NullableLambda<E> {
        let value = this.value
        guard value.count > 0 else { return NullableLambda<E>(nil) }
        return NullableLambda<E>(value[value.count-1])
    }
    
    public var middleLeft: NullableLambda<E> {
        let value = this.value
        guard value.count > 0 else { return NullableLambda<E>(nil) }
        return NullableLambda<E>(value[value.count % 2 == 0 ? value.count/2-1 : value.count/2])
    }
    
    public var middleRight: NullableLambda<E> {
        let value = this.value
        guard value.count > 0 else { return NullableLambda<E>(nil) }
        return NullableLambda<E>(value[value.count/2])
    }
    
    public var splitLeft: (left: LambdaArray<E>, right: LambdaArray<E>) {
        let value = this.value
        guard value.count > 0 else { return (LambdaArray<E>([]), LambdaArray<E>([])) }
        let count = value.count
        let left = value.prefix(through: count / 2 - 1).map {$0}
        let right = value.suffix(from: count / 2).map {$0}
        return (LambdaArray<E>(left), LambdaArray<E>(right))
    }
    
    public var splitRight: (left: LambdaArray<E>, right: LambdaArray<E>) {
        let value = this.value
        guard value.count > 0 else { return (LambdaArray<E>([]), LambdaArray<E>([])) }
        let count = value.count
        let plus = count % 2 == 1 ? 1 : 0
        let left = value.prefix(through: count / 2 - 1 + plus).map {$0}
        let right = value.suffix(from: count / 2 + plus).map {$0}
        return (LambdaArray<E>(left), LambdaArray<E>(right))
    }
    
    public func at(_ indexs: Int...) -> LambdaArray<E> {
        let value = this.value
        guard value.count > 0 else { return LambdaArray<E>([]) }
        var array: [E] = []
        for i in indexs {
            array.append(value[i])
        }
        return LambdaArray<E>(array)
    }
    
}

extension LambdaArray: Sequence, IteratorProtocol {
    
    public typealias Element = E
    
    public func next() -> E? {
        return nil
    }
    
}

extension LambdaArray {
    
    public func change<T>(_ function: (E) throws -> T) -> LambdaArray<T> {
        let value = this.value
        var array: [T] = []
        for item in value {
            if let result = try? function(item) {
                array.append(result)
            }
        }
        return LambdaArray<T>(array)
    }
    
    public func change<T>(_ function: (E) throws -> T?) rethrows -> LambdaArray<T> {
        let value = this.value
        var array: [T] = []
        for item in value {
            if let result = try? function(item), let resultNotNull = result {
                array.append(resultNotNull)
            }
        }
        return LambdaArray<T>(array)
    }
    
    public func cast<T>(_ type: T.Type) -> LambdaArray<T> {
        let value = this.value
        var array: [T] = []
        for item in value {
            if let cast = item as? T {
                array.append(cast)
            }
        }
        return LambdaArray<T>(array)
    }
    
}

extension LambdaArray {
    
    public func group<U: Hashable>(_ callback: (E) throws -> U) rethrows -> LambdaDictionary<U, LambdaArray<E>> {
        var grouped = [U: LambdaArray<E>]()
        for element in this.value {
            let key = try callback(element)
            if let arr = grouped[key] {
                arr.this.value.append(element)
            } else {
                grouped[key] = LambdaArray<E>([element])
            }
        }
        return LambdaDictionary<U, LambdaArray<E>>(grouped)
    }
    
}

extension LambdaArray {
    
    public func dic<K: Hashable, V>(_ callback: (E) throws -> (K,V)) rethrows -> LambdaDictionary<K, V> {
        let value = this.value
        var dic = [K: V]()
        for element in value {
            let (k,v) = try callback(element)
            dic[k] = v
        }
        return LambdaDictionary<K, V>(dic)
    }
    
}

extension LambdaArray {
    
    public func flat<T>(_ callback: (E) throws -> [T]) rethrows -> LambdaArray<T> {
        let value = this.value
        var array: [T] = []
        for elem: E in value {
            let item = try callback(elem)
            array.append(contentsOf: item)
        }
        return LambdaArray<T>(array)
    }
    
}

extension LambdaArray where E: Hashable {
    
    public func flatten(_ callback: (E) throws -> [E]) rethrows -> LambdaArray<E> {
        let value = this.value
        var set: Set<E> = Set<E>(value)
        var list: [E] = value
        var i = 0
        while i < list.count {
            let elem = list[i]
            let flat = try callback(elem)
            for item in flat {
                if !set.contains(item) {
                    set.insert(item)
                    list.append(item)
                }
            }
            i += 1
        }
        return LambdaArray<E>(set.map({$0}))
    }
    
}

extension LambdaArray where E: Equatable {
    
    public static func ==(lhs: LambdaArray<E>, rhs: LambdaArray<E>) -> Bool {
        return lhs.this.value.elementsEqual(rhs.this.value)
    }
    
}

extension LambdaArray where E: Hashable {
    
    public var hashValue: Int {
        let value = this.value
        return value.reduce(1, { $0 * 31 + $1.hashValue })
    }
    
}

extension LambdaArray where E: Comparable {
    
    public func max() -> E? {
        if self.this.value.count == 0 { return nil }
        var result = self.this.value[0]
        for item in self.this.value {
            if item > result {
                result = item
            }
        }
        return result
    }
    
    public func min() -> E? {
        if self.this.value.count == 0 { return nil }
        var result = self.this.value[0]
        for item in self.this.value {
            if item < result {
                result = item
            }
        }
        return result
    }
    
}

extension LambdaArray: CustomStringConvertible {
    
    public var description: String {
        return value.description
    }
    
}
