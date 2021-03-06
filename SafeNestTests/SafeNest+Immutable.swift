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
  public func test_ensuringImmutability() throws {
    /// Setup
    let array = NSArray(arrayLiteral: 1, 2, 3)
    let dict = NSDictionary(dictionaryLiteral: ("a", 1), ("b", array))
    var nest = SafeNest.builder().with(initialObject: dict).build()
    
    /// When
    _ = try nest.update(at: "a", value: 10)
    _ = try nest.update(at: "b.10", value: 20)
    
    /// Then
    XCTAssertEqual(nest.value(at: "a").value as? Int, 10)
    XCTAssertEqual(nest.value(at: "b.10").value as? Int, 20)
    XCTAssertNotEqual(nest.value(at: "a").value as? Int, dict["a"] as? Int)
    XCTAssertNotEqual(nest.value(at: "b").value as? [Int?], array as? [Int?])
  }
  
  public func test_cloneShouldCopyOnWrite() throws {
    /// Setup
    let nest = SafeNest.builder().with(initialObject: ["a": 1]).build()
    
    /// When
    let cloned = try nest.updating(at: "a", value: 2)
    
    /// Then
    XCTAssertNotEqual(nest.value(at: "a").value as? Int,
                      cloned.value(at: "a").value as? Int)
  }
}
