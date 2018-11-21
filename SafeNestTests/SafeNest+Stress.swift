//
//  SafeNest+Stress.swift
//  SafeNestTests
//
//  Created by Hai Pham on 11/21/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import XCTest
@testable import SafeNest

public final class StressTests: XCTestCase {
  let alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  let separator = "&"
  let keyIdentifier = "stress"
  let countPerLevel = 4
  let maxLevel = 8
  
  enum PossibleValueTypes: CaseIterable {
    case array
    case dict
    case string
  }
  
  override public func setUp() {
    super.setUp()
    self.continueAfterFailure = false
  }
  
  func randomString(_ length: Int) -> String {
    return String((0..<length).map({_ in alphabets.randomElement()!}))
  }
  
  func createAlphabeticalLevels(_ levelCount: Int) -> [String] {
    return Array(self.alphabets)
      .prefix(levelCount)
      .map({"\(self.keyIdentifier)\(String($0))"})
  }
  
  func createAllKeys(_ levels: [String], _ countPerLevel: Int) -> [String] {
    let sep = self.separator
    let subLength = levels.count
    let last = levels[subLength - 1]
    
    if (subLength == 1) {
      return (0..<countPerLevel).map({"\(last)\($0)"})
    }
  
    let subKeys = self.createAllKeys(Array(levels.prefix(subLength - 1)), countPerLevel)
    let lastKeys = createAllKeys([last], countPerLevel)
    return subKeys.map({key in lastKeys.map({key + sep + $0})}).reduce([], +)
  }
  
  func createCombinations(_ levels: [String], _ countPerLevel: Int) -> [String : Any] {
    var allCombinations: [String : Any] = [:]
    let allKeys = self.createAllKeys(levels, countPerLevel)
    let possibleValueTypes = PossibleValueTypes.allCases
    
    let randomizeData: () -> Any = {
      let randomType = possibleValueTypes.randomElement()!
      
      switch randomType {
      case .array:
        return (0..<5).map({_ in self.randomString(10)})
        
      case .dict:
        return (0...5).map({[String($0) : self.randomString(10)]})
          .reduce([String : String](), {$0.merging($1, uniquingKeysWith: +)})
      
      case .string:
        return self.randomString(10)
      }
    }
    
    allKeys.forEach({allCombinations[$0] = randomizeData()})
    return allCombinations
  }
  
  func createSafeNest(_ combinations: [String : Any]) throws -> SafeNest {
    var nest = SafeNest().with(pathSeparator: separator)
    try combinations.forEach({_ = try nest.update(at: $0, value: $1)})
    return nest;
  }
  
  func checkEqual(_ value1: Any, _ value2: Any) {
    if let arr1 = value1 as? [String], let arr2 = value2 as? [String] {
      XCTAssertEqual(arr1, arr2)
    } else if
      let dict1 = value1 as? [String : String],
      let dict2 = value2 as? [String : String]
    {
      XCTAssertEqual(dict1, dict2)
    } else if let str1 = value1 as? String, let str2 = value2 as? String {
      XCTAssertEqual(str1, str2)
    } else {
      XCTFail("Unsupported data types for " +
        "\(String(describing: value1)) and " +
        "\(String(describing: value2))")
    }
  }
  
  public func test_copyAndMoveValues() throws {
    for i in 2..<maxLevel {
      /// Setup
      let levels = self.createAlphabeticalLevels(i)
      let allKeys = self.createAllKeys(levels, self.countPerLevel)
      let allCombinations = self.createCombinations(levels, self.countPerLevel)
      let nest = try self.createSafeNest(allCombinations)
      
      /// When
      for srcPath in allKeys {
        var destPath: String
        
        repeat {
          destPath = allKeys.randomElement()!
        } while destPath == srcPath
        
        let srcValue = try nest.value(at: srcPath).getOrThrow()
        let copied = try nest.copying(from: srcPath, to: destPath)
        let moved = try nest.moving(from: srcPath, to: destPath)
        
        /// Then
        XCTAssertTrue(copied.value(at: srcPath).isSuccess)
        XCTAssertTrue(copied.value(at: destPath).isSuccess)
        XCTAssertTrue(moved.value(at: srcPath).isFailure)
        XCTAssertTrue(moved.value(at: destPath).isSuccess)
        checkEqual(try copied.value(at: destPath).getOrThrow(), srcValue)
        checkEqual(try moved.value(at: destPath).getOrThrow(), srcValue)
      }
    }
  }
}
