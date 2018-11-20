//
//  SafeNest+Modify.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public extension SafeNest {

  /// Maps a value at a node internally. This method mutates.
  ///
  /// - Parameters:
  ///   - mapper: The mapper function.
  ///   - subpaths: An Array of subpaths to access and update the nested value.
  /// - Returns: The old value found at the end of the paths.
  /// - Throws: If mapping fails.
  private mutating func _map(_ mapper: (Any?) throws -> Any,
                             _ subpaths: [String]) throws -> Any? {
    var oldValue: Any? = nil
    
    if let subpath0 = subpaths.first {
      if subpaths.count == 1 {
        let (updated, old) = try mapObjectPath(self.object, subpath0, mapper)
        self.set(object: updated)
        oldValue = old
      } else if subpaths.count > 1 {
        let object0 = accessObjectPath(self.object, subpath0) ?? [String : Any]()
        var subNest = self.cloned()
        subNest.set(object: object0)
        oldValue = try subNest._map(mapper, Array(subpaths[1...]))
        let (updated, _) = try updateObjectPath(self.object, subpath0, subNest.object)
        self.set(object: updated)
      }
    }
    
    return oldValue
  }
  
  /// Public method for mapping. Here we split the node path into components
  /// and feed them to an internal mapping method.
  ///
  /// - Parameters:
  ///   - fn: The mapper function.
  ///   - node: The path at which to map.
  /// - Returns: The old value found at the specified node.
  /// - Throws: If mapping fails.
  public mutating func map(withMapper fn: (Any?) throws -> Any,
                           at node: String) throws -> Any? {
    let nodeComponents = node.components(separatedBy: self.pathSeparator)
    return try self._map(fn, nodeComponents)
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
    _ = try clonedNest.map(withMapper: fn, at: node)
    return clonedNest
  }
}

public extension SafeNest {

  /// Instead of mapping a value, simply replaces it. This method mutates.
  ///
  /// - Parameters:
  ///   - value: The value to update.
  ///   - node: The path at which to update.
  /// - Returns: The old value found at specified node.
  /// - Throws: If updating fails.
  public mutating func update(value: Any, at node: String) throws -> Any? {
    return try self.map(withMapper: {_ in value}, at: node)
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

public extension SafeNest {
  
  /// Copies value from one path to another. This method mutates.
  ///
  /// - Parameters:
  ///   - node1: The path at which the copied value is found.
  ///   - node2: The path to copy the value to.
  /// - Returns: The old value found at the second node.
  /// - Throws: If copying fails.
  public mutating func copy(from node1: String, to node2: String) throws -> Any? {
    let copiedValue = self.value(at: node1).value
    return try self.update(value: copiedValue as Any, at: node2)
  }
  
  /// Copies value from one path to another and return a new nest.
  ///
  /// - Parameters:
  ///   - node1: The path at which the copied value is found.
  ///   - node2: The path to copy the value to.
  /// - Returns: A new nest.
  /// - Throws: If copying fails.
  public func copying(from node1: String, to node2: String) throws -> SafeNest {
    var clonedNest = self.cloned()
    _ = try clonedNest.copy(from: node1, to: node2)
    return clonedNest
  }
}
