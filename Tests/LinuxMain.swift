//
//  LambdaTests.swift
//  Lambda
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import LambdaTests

extension LambdaTests {

	static var allTests : [(String, (LambdaTests) -> () throws -> Void)] {
		return [
			("testAt", testAt),
			("testExample", testExample),
			("testFilterArray", testFilterArray),
			("testMapGroup", testMapGroup),
			("testMapSubscript", testMapSubscript),
			("testMapType", testMapType),
			("testSplit", testSplit),
		]
	}

}

XCTMain([
	testCase(LambdaTests.allTests),
])

