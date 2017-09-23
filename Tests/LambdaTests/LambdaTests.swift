import XCTest
import Foundation
@testable import Lambda

class LambdaTests: XCTestCase {

    func testExample() {
        XCTAssertEqual(1, [].lambda.first.empty({1}).get)
        XCTAssertEqual([1,2,3], [1,2,3].lambda.value)
        
        XCTAssertEqual(1, try [1,2,3].lambda.first.get())
        
        XCTAssertEqual(3, try [1,2,3].lambda.last.get())
        
        XCTAssertEqual(1, try [[1,2,3].lambda].lambda.first.get().first.get())
        
        XCTAssertEqual(2, try [1,2,3].lambda.middleLeft.get())
        XCTAssertEqual(2, try [1,2,3].lambda.middleRight.get())
        XCTAssertEqual(2, try [1,2,3,4].lambda.middleLeft.get())
        XCTAssertEqual(3, try [1,2,3,4].lambda.middleRight.get())
    }
    
    func testSplit() {
        XCTAssertEqual([], [1].lambda.splitLeft.left.value)
        XCTAssertEqual([1].lambda.description, [1].lambda.splitLeft.right.description)
        XCTAssertEqual([1].lambda.description, [1].lambda.splitRight.left.description)
        XCTAssertEqual([].lambda.description, [1].lambda.splitRight.right.description)
        
        XCTAssertEqual([1].lambda.description, [1,2].lambda.splitLeft.left.description)
        XCTAssertEqual([2].lambda.description, [1,2].lambda.splitLeft.right.description)
        XCTAssertEqual([1].lambda.description, [1,2].lambda.splitRight.left.description)
        XCTAssertEqual([2].lambda.description, [1,2].lambda.splitRight.right.description)
        
        XCTAssertEqual([1].lambda.description, [1,2,3].lambda.splitLeft.left.description)
        XCTAssertEqual([2,3].lambda.description, [1,2,3].lambda.splitLeft.right.description)
        XCTAssertEqual([1,2].lambda.description, [1,2,3].lambda.splitRight.left.description)
        XCTAssertEqual([3].lambda.description, [1,2,3].lambda.splitRight.right.description)
        
        XCTAssertEqual([1,2].lambda.description, [1,2,3,4].lambda.splitLeft.left.description)
        XCTAssertEqual([3,4].lambda.description, [1,2,3,4].lambda.splitLeft.right.description)
        XCTAssertEqual([1,2].lambda.description, [1,2,3,4].lambda.splitRight.left.description)
        XCTAssertEqual([3,4].lambda.description, [1,2,3,4].lambda.splitRight.right.description)
    }
    
    func testAt() {
        XCTAssertEqual([1,3,5], [1,2,3,4,5].lambda.at(0,2,4).value)
    }
    
    func testFilterArray() {
        XCTAssertEqual([1,3,5], [1,2,3,4,5].lambda.filter({$0 % 2 == 1}).value)
    }
    
    func testMapType() {
        XCTAssertEqual(NSNumber(value: 1) as NSObject, NSNumber(value: 1) as NSObject)
        XCTAssertEqual(NSNumber(value: 1) as NSObject, try [NSNumber(value: 1)].lambda.first.map(NSObject.self).get())
        XCTAssertEqual(NSNumber(value: 1) as NSObject, try [NSNumber(value: 1)].lambda.first.map(Any.self).map(NSObject.self).get())
        XCTAssertEqual([1,3,5,7], [1,"2",3,"4",5,false,7].lambda.cast(Int.self).value)
        XCTAssertEqual(["2","4"], [1,"2",3,"4",5,false,7].lambda.cast(String.self).value)
        XCTAssertEqual([false], [1,"2",3,"4",5,false,7].lambda.cast(Bool.self).value)
    }
    
    func testMapSubscript() {
        XCTAssertEqual(1, try ["id":1].lambda["id"].get())
        XCTAssertEqual(2, try ["id":1].lambda.put(key: "id", value: 2)["id"].get())
    }
    
    func testMapGroup() {
        struct A {
            let id: Int
            let name: String
        }
        let array = [A(id:1,name:"a"),A(id:2,name:"b"),A(id:1,name:"c"),A(id:2,name:"d"),A(id:1,name:"e")]
        XCTAssertEqual(["a","c","e"], try array.lambda.group({$0.id})[1].get().change({$0.name}).value)
        XCTAssertEqual(["b","d"], try array.lambda.group({$0.id})[2].get().change({$0.name}).value)
        XCTAssertTrue(array.lambda.group({$0.id})[3].empty)
    }
    
}
