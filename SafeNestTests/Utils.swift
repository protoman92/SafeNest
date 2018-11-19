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
  public func test_accessAndUpdateDict() {
    /// Setup
    let dict = ["1" : 2]
    
    /// When && Then
    XCTAssertEqual(accessObjectPath(dict, "1") as? Int, 2)
    XCTAssertEqual(try! updateObjectPath(dict, "1", 3) as? [String : Int], ["1" : 3])
  }
  
  public func test_accessAndUpdateArray() {
    /// Setup
    let arr = [1, 2, 3]
    
    /// When && Then
    XCTAssertEqual(accessObjectPath(arr, "0") as? Int, 1)
    XCTAssertEqual(accessObjectPath(arr, "1") as? Int, 2)
    XCTAssertEqual(accessObjectPath(arr, "2") as? Int, 3)
    XCTAssertEqual(try! updateObjectPath(arr, "0", 5) as? [Int], [5, 2, 3])
    XCTAssertEqual(try! updateObjectPath(arr, "1", 6) as? [Int], [1, 6, 3])
    XCTAssertEqual(try! updateObjectPath(arr, "2", 7) as? [Int], [1, 2, 7])
  }
}
