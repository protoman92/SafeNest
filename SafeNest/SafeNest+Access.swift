//
//  SafeNest+Access.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public extension SafeNest {

  /// Access a value at a nested node.
  ///
  /// - Parameter node: The path at which to find the value.
  /// - Returns: A Try instance containing either the value or an access error.
  public func value(at node: String) -> Try<Any> {
    let subpaths = node.components(separatedBy: self._pathSeparator)
    var currentResult: Any = self._object
    
    for subpath in subpaths {
      guard let interResult = accessObjectPath(currentResult, subpath) else {
        return Try.failure("No value found at \(node)")
      }
      
      currentResult = interResult
    }
    
    return Try(currentResult)
  }
}
