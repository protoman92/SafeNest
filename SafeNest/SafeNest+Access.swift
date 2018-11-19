//
//  SafeNest+Access.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

extension SafeNestType {
  func value(at node: String) -> Try<Any> {
    let subpaths = node.components(separatedBy: self.pathSeparator)
    var currentResult: Any = self.object
    
    for subpath in subpaths {
      if
        let dict = currentResult as? [String : Any],
        let intermediateResult = dict[subpath] {
        currentResult = intermediateResult
      } else if let pathInt = Int(subpath), let arr = currentResult as? [Any] {
        currentResult = arr[pathInt]
      } else {
        return Try.failure("No value found at \(node)")
      }
    }
    
    return Try.success(currentResult)
  }
}
