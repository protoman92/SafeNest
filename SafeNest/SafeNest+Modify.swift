//
//  SafeNest+Modify.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

extension SafeNest {
  private mutating func _map(_ mapper: (Any?) throws -> Any,
                             _ subpaths: [String]) throws -> SafeNest {
    if let subpath0 = subpaths.first {
      if subpaths.count == 1 {
        let updated = try mapObjectPath(self._object, subpath0, mapper)
        self.set(object: updated)
      } else if subpaths.count > 1 {
        let object0 = accessObjectPath(self._object, subpath0) ?? [String : Any]()
        var subNest = self.cloned()
        subNest.set(object: object0)
        let updated0 = try subNest._map(mapper, Array(subpaths[1...]))._object
        let updated = try updateObjectPath(self._object, subpath0, updated0)
        self.set(object: updated)
      }
    }

    return self
  }
  
  public mutating func map(withMapper fn: (Any?) throws -> Any,
                           at node: String) throws -> SafeNest {
    let nodeComponents = node.components(separatedBy: self._pathSeparator)
    return try self._map(fn, nodeComponents)
  }
  
  public mutating func update(value: Any, at node: String) throws -> SafeNest {
    return try self.map(withMapper: {_ in value}, at: node)
  }
}
