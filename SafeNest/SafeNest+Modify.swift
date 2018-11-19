//
//  SafeNest+Modify.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public extension SafeNest {

  /// Map a value at a node internally. This method mutates.
  ///
  /// - Parameters:
  ///   - mapper: The mapper function.
  ///   - subpaths: An Array of subpaths to access and update the nested value.
  /// - Throws: If mapping fails.
  private mutating func _map(_ mapper: (Any?) throws -> Any,
                             _ subpaths: [String]) throws {
    if let subpath0 = subpaths.first {
      if subpaths.count == 1 {
        let updated = try mapObjectPath(self.object, subpath0, mapper)
        self.set(object: updated)
      } else if subpaths.count > 1 {
        let object0 = accessObjectPath(self.object, subpath0) ?? [String : Any]()
        var subNest = self.cloned()
        subNest.set(object: object0)
        try subNest._map(mapper, Array(subpaths[1...]))
        let updated = try updateObjectPath(self.object, subpath0, subNest.object)
        self.set(object: updated)
      }
    }
  }
  
  /// Public method for mapping. Here we split the node path into components
  /// and feed them to an internal mapping method.
  ///
  /// - Parameters:
  ///   - fn: The mapper function.
  ///   - node: The path at which to map.
  /// - Throws: If mapping fails.
  public mutating func map(withMapper fn: (Any?) throws -> Any,
                           at node: String) throws {
    let nodeComponents = node.components(separatedBy: self.pathSeparator)
    try self._map(fn, nodeComponents)
  }
  
  /// This method maps, but does not mutate because it returns a new nest.
  ///
  /// - Parameters:
  ///   - fn: The mapper function.
  ///   - node: The path at which to map.
  /// - Returns: A new nest.
  /// - Throws: If mapping fails.
  public func mapping(withMapper fn: (Any?) throws -> Any,
                      at node: String) throws -> SafeNest {
    var clonedNest = self.cloned()
    try clonedNest.map(withMapper: fn, at: node)
    return clonedNest
  }
}

public extension SafeNest {

  /// Instead of mapping a value, simply replace it. This method mutates.
  ///
  /// - Parameters:
  ///   - value: The value to update.
  ///   - node: The path at which to update.
  /// - Throws: If updating fails.
  public mutating func update(value: Any, at node: String) throws {
    try self.map(withMapper: {_ in value}, at: node)
  }
  
  /// Updates but does not mutate, instead returns a new nest.
  ///
  /// - Parameters:
  ///   - value: The value to update.
  ///   - node: The path at which to update.
  /// - Returns: A new nest.
  /// - Throws: If updating fails.
  public func updating(value: Any, at node: String) throws -> SafeNest {
    return try self.mapping(withMapper: {_ in value}, at: node)
  }
}
