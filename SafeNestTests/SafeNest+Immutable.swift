//
//  SafeNest+Immutable.swift
//  SafeNestTests
//
//  Created by Hai Pham on 11/20/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import XCTest
@testable import SafeNest

public final class ImmutableTests: XCTestCase {
  public func test_ensuringImmutability() {
    /// Setup
    let array = NSArray(arrayLiteral: 1, 2, 3)
    let dict = NSDictionary(dictionaryLiteral: ("a", 1), ("b", array))
    var nest = SafeNest(initialObject: dict)
    
    /// When
    try! nest.update(value: 10, at: "a")
    try! nest.update(value: 20, at: "b.10")
    
    /// Then
    XCTAssertEqual(nest.value(at: "a").value as? Int, 10)
    XCTAssertEqual(nest.value(at: "b.10").value as? Int, 20)
    XCTAssertNotEqual(nest.value(at: "a").value as? Int, dict["a"] as? Int)
    XCTAssertNotEqual(nest.value(at: "b").value as? [Int?], array as? [Int?])
  }
}
