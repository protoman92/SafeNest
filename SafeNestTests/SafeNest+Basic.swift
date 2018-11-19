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
          "c1": [
            "d1": 1,
            "d2": 2
          ],
          "c2": [
            "d3": [1, 2, 3]
          ]
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
}
