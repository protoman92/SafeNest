//
//  SafeNest.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public struct SafeNest {
  var _object: Any
  var _pathSeparator: String
  
  public var object: Any {
    return self._object
  }
  
  public var pathSeparator: Any {
    return self._pathSeparator
  }
  
  public init(object: Any = [:], pathSeparator: String = ".") {
    self._object = object
    self._pathSeparator = pathSeparator
  }
  
  mutating func set(object: Any) {
    self._object = object
  }
  
  func cloned() -> SafeNest {
    return SafeNest(object: self._object, pathSeparator: self._pathSeparator)
  }
}
