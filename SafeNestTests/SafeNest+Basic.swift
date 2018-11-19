//
//  SafeNest+Basic.swift
//  SafeNestTests
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import XCTest
@testable import SafeNest

public final class BasicTests: XCTestCase {
  private var safeNest: SafeNest!;
  
  override public func setUp() {
    super.setUp()
    
    self.safeNest = SafeNest(object: [
      "a1": [
        "b1": [
          "c1": ["d1": 1, "d2": 2],
          "c2": ["d3": [1, 2, 3]]
        ],
        "b2": ["c2": 10],
        "b3": 100
      ]
      ])
  }
  
  public func test_accessNestedProps() {
    /// Setup
    let safeNest = self.safeNest!
    
    /// When && Then
    XCTAssertEqual(safeNest.value(at: "a1.b1.c1.d1").cast(Int.self).value, 1)
    XCTAssertEqual(safeNest.value(at: "a1.b1.c2.d3.0").cast(Int.self).value, 1)
  }
  
  public func test_updateNestedProps() {
    /// Setup
    var safeNest = self.safeNest!
    let path1 = "a1.b2.c3.d1.e1"
    let path2 = "a1.b1.c1.d1"
    let path3 = "a2.b10.10.c19.d190"
    let path4 = "a1.b1.c2.d3.10.e99"
    let value1 = 2
    let value2 = 100
    let value3 = "Hello world"
    let value4 = ["z10": 200]
    
    /// When
    safeNest = try! safeNest.update(value: value1, at: path1)
    safeNest = try! safeNest.update(value: value2, at: path2)
    safeNest = try! safeNest.update(value: value3, at: path3)
    safeNest = try! safeNest.update(value: value4, at: path4)
    
    /// Then
    XCTAssertEqual(safeNest.value(at: path1).value as? Int, value1)
    XCTAssertEqual(safeNest.value(at: path2).value as? Int, value2)
    XCTAssertEqual(safeNest.value(at: path3).value as? String, value3)
    XCTAssertEqual(safeNest.value(at: "\(path4).z10").value as? Int, value4["z10"])
  }
}
