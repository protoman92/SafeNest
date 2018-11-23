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
  public static func builder() -> Builder {
    return Builder()
  }
  
  private var _object: Any?
  private var _pathSeparator: String
  private var _jsonEncoder: JSONEncoder
  private var _jsonDecoder: JSONDecoder
  
  public var object: Any? {
    return self._object
  }
  
  public var pathSeparator: String {
    return self._pathSeparator
  }
  
  public var jsonEncoder: JSONEncoder {
    return self._jsonEncoder
  }
  
  public var jsonDecoder: JSONDecoder {
    return self._jsonDecoder
  }
  
  private init() {
    self._object = [String : Any]()
    self._pathSeparator = "."
    self._jsonEncoder = JSONEncoder()
    self._jsonDecoder = JSONDecoder()
  }
  
  public func cloneBuilder() -> Builder {
    return SafeNest.builder().with(nest: self)
  }
  
  public func clone() -> SafeNest {
    return self
  }
  
  mutating func setUnsafely(_ object: Any?) {
    self._object = object
  }
  
  public final class Builder {
    private var nest: SafeNest
    
    fileprivate init() {
      self.nest = SafeNest()
    }
    
    public func with(initialObject: Any?) -> Self {
      self.nest._object = initialObject
      return self
    }
    
    public func with(json: Data) throws -> Self {
      let object = try JSONSerialization.jsonObject(with: json, options: .allowFragments)
      return self.with(initialObject: object)
    }
    
    public func with(pathSeparator: String) -> Self {
      self.nest._pathSeparator = pathSeparator
      return self
    }
    
    public func with(jsonEncoder: JSONEncoder) -> Self {
      self.nest._jsonEncoder = jsonEncoder
      return self
    }
    
    public func with(jsonDecoder: JSONDecoder) -> Self {
      self.nest._jsonDecoder = jsonDecoder
      return self
    }
    
    public func with(nest: SafeNest) -> Self {
      self.nest = nest
      return self
    }
    
    public func build() -> SafeNest {
      return self.nest
    }
  }
}
