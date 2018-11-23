//
//  SafeNest+Access.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public extension SafeNest {

  /// Access a value at a nested node. If the node path is an empty string,
  /// return the whole object.
  ///
  /// - Parameter node: The path at which to find the value.
  /// - Returns: A Try instance containing either the value or an access error.
  public func value(at node: String = "") -> Try<Any> {
    let subpaths = node.components(separatedBy: self.pathSeparator)
    var currentResult: Any? = self.object
    
    for subpath in subpaths {
      if let interResult = accessObjectPath(currentResult, subpath) {
        currentResult = interResult
      } else {
        currentResult = nil
        break
      }
    }
    
    if let currentResult = currentResult {
      return Try.success(currentResult)
    }
    
    return Try.failure("No value found at \(node)")
  }
}

public extension SafeNest {
  
  /// Decode a value at a nested node.
  ///
  /// - Parameters:
  ///   - node: The path at which to find the value.
  ///   - type: The decodable type.
  /// - Returns: A Try instance containing the decodable.
  public func decode<D>(at node: String, ofType type: D.Type) -> Try<D> where D: Decodable {
    return self.value(at: node)
      .map({try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted)})
      .map({try self.jsonDecoder.decode(type, from: $0)})
  }
}
