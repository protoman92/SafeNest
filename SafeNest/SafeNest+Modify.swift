//
//  SafeNest+Modify.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public extension SafeNest {
  private mutating func _map(_ mapper: (Any?) throws -> Any,
                             _ subpaths: [String]) throws {
    if let subpath0 = subpaths.first {
      if subpaths.count == 1 {
        let updated = try mapObjectPath(self._object, subpath0, mapper)
        self.set(object: updated)
      } else if subpaths.count > 1 {
        let object0 = accessObjectPath(self._object, subpath0) ?? [String : Any]()
        var subNest = self.cloned()
        subNest.set(object: object0)
        try subNest._map(mapper, Array(subpaths[1...]))
        let updated = try updateObjectPath(self._object, subpath0, subNest._object)
        self.set(object: updated)
      }
    }
  }
  
  public mutating func map(withMapper fn: (Any?) throws -> Any,
                           at node: String) throws {
    let nodeComponents = node.components(separatedBy: self._pathSeparator)
    try self._map(fn, nodeComponents)
  }
  
  public func mapping(withMapper fn: (Any?) throws -> Any,
                      at node: String) throws -> SafeNest {
    var clonedNest = self.cloned()
    try clonedNest.map(withMapper: fn, at: node)
    return clonedNest
  }
}

public extension SafeNest {
  public mutating func update(value: Any, at node: String) throws {
    try self.map(withMapper: {_ in value}, at: node)
  }
  
  public func updating(value: Any, at node: String) throws -> SafeNest {
    return try self.mapping(withMapper: {_ in value}, at: node)
  }
}
