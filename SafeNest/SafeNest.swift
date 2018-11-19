//
//  SafeNest.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

/// This data type attempts to provide a JSON-like structure by allowing
/// dynamic data to be stored and accessed. We can feed different types of
/// objects (e.g. dicts and arrays) and access nested properties with a string
/// key (joined by path separator). For e.g.:
///
/// safeNest.value(at: "a.b.c.d"
/// safeNest.update(value: 1, at: "a.b.c.d")
///
/// For updating, the nest will create new sub-nests along the way if there is
/// none. That means for path "a.b.c.d", if the value found at "a.b" has no
/// property "c", we create a default dict and set it to "a.b.c".
///
/// For now, only several data types are supported, namely dicts and arrays.
/// This should suffice for most situations, however.
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
