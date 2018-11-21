//
//  Utils.swift
//  SafeNestTests
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import XCTest
@testable import SafeNest

public final class UtilTests: XCTestCase {
  public func test_accessAndUpdateDict() throws {
    /// Setup
    let dict = ["1" : 2]
    
    /// When
    let (updated1, old1) = try updateObjectPath(dict, "1", 3)
    
    /// Then
    XCTAssertEqual(accessObjectPath(dict, "1") as? Int, 2)
    XCTAssertEqual(updated1 as? [String : Int], ["1" : 3])
    XCTAssertEqual(old1 as? Int, 2)
  }
  
  public func test_accessAndUpdateArray() throws {
    /// Setup
    let arr = [1, 2, 3]
    
    /// When
    let (updated1, old1) = try updateObjectPath(arr, "0", 5)
    let (updated2, old2) = try updateObjectPath(arr, "1", 6)
    let (updated3, old3) = try updateObjectPath(arr, "2", 7)
    let (updated4, old4) = try updateObjectPath(arr, "5", 1)
    
    /// Then
    XCTAssertEqual(accessObjectPath(arr, "0") as? Int, 1)
    XCTAssertEqual(accessObjectPath(arr, "1") as? Int, 2)
    XCTAssertEqual(accessObjectPath(arr, "2") as? Int, 3)
    XCTAssertEqual(updated1 as? [Int], [5, 2, 3])
    XCTAssertEqual(updated2 as? [Int], [1, 6, 3])
    XCTAssertEqual(updated3 as? [Int], [1, 2, 7])
    XCTAssertEqual(updated4 as? [Int?], [1, 2, 3, nil, nil, 1])
    XCTAssertEqual(old1 as? Int, 1)
    XCTAssertEqual(old2 as? Int, 2)
    XCTAssertEqual(old3 as? Int, 3)
    XCTAssertEqual(old4 as? Int, nil)
    XCTAssertThrowsError(try updateObjectPath(arr, "-1", 1)) {XCTAssertTrue($0 is SafeNestError)}
  }
}
