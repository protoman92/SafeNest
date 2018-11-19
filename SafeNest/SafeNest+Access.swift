//
//  SafeNest+Access.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

extension SafeNest {
  func value(at node: String) -> Try<Any> {
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
