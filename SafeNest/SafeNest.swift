//
//  SafeNest.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

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
  private var _object: Any?
  private var _pathSeparator: String
  let _jsonDecoder: JSONDecoder
  
  public var object: Any? {
    return self._object
  }
  
  public var pathSeparator: String {
    return self._pathSeparator
  }
  
  public init(initialObject: Any? = [:]) {
    self._object = initialObject
    self._pathSeparator = "."
    self._jsonDecoder = JSONDecoder()
  }
  
  mutating func set(object: Any?) {
    self._object = object
  }
  
  mutating func set(pathSeparator: String) {
    self._pathSeparator = pathSeparator
  }
  
  public func cloned() -> SafeNest {
    var newNest = SafeNest(initialObject: self._object)
    newNest.set(pathSeparator: self._pathSeparator)
    return newNest
  }
  
  public func with(object: Any) -> SafeNest {
    var clonedNest = self.cloned()
    clonedNest.set(object: object)
    return clonedNest
  }
  
  public func with(json: Data) throws -> SafeNest {
    let object = try JSONSerialization.jsonObject(with: json, options: .allowFragments)
    return self.with(object: object)
  }
  
  public func with(pathSeparator: String) -> SafeNest {
    var clonedNest = self.cloned()
    clonedNest.set(pathSeparator: pathSeparator)
    return clonedNest
  }
}
