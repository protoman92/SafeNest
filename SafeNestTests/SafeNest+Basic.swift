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
    
    self.safeNest = SafeNest(initialObject: [
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
    let path5 = "a1.b1.c2.d3.1"
    let value1 = 2
    let value2 = 100
    let value3 = "Hello world"
    let value4 = ["z10": 200]
    
    /// When
    let old1 = try! safeNest.update(value: value1, at: path1)
    let old2 = try! safeNest.update(value: value2, at: path2)
    
    safeNest = try! safeNest
      .updating(value: value3, at: path3)
      .updating(value: value4, at: path4)
      .mapping(withMapper: {"\($0!)"}, at: path5)
    
    /// Then
    XCTAssertNil(old1)
    XCTAssertEqual(old2 as? Int, 1)
    XCTAssertEqual(safeNest.value(at: path1).value as? Int, value1)
    XCTAssertEqual(safeNest.value(at: path2).value as? Int, value2)
    XCTAssertEqual(safeNest.value(at: path3).value as? String, value3)
    XCTAssertEqual(safeNest.value(at: "\(path4).z10").value as? Int, value4["z10"])
    XCTAssertEqual(safeNest.value(at: path5).value as? String, "2")
  }
  
  public func test_copyAndMoveNestedProps() {
    /// Setup
    var safeNest = self.safeNest!
    let path1 = "a1.b1.c2.d3.2"
    let path2 = "a10.b3.c10.d12.e13.f15"
    let path3 = "a1.b3"
    let path4 = "a1.b2.c2"
    
    /// When
    let old12 = try! safeNest.copy(from: path1, to: path2)
    let old34 = try! safeNest.move(from: path3, to: path4)
    
    /// Then
    XCTAssertNil(old12)
    XCTAssertEqual(old34 as? Int, 10)
    
    XCTAssertEqual(safeNest.value(at: path1).value as! Int,
                   safeNest.value(at: path2).value as! Int)
    
    XCTAssertNil(safeNest.value(at: path3).value)
    XCTAssertEqual(safeNest.value(at: path4).value as? Int, 100)
  }
}
