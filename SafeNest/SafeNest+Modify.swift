//
//  SafeNest+Modify.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

public extension SafeNest {

  /// Maps a value at a node internally. This method mutates.
  ///
  /// - Parameters:
  ///   - subpaths: An Array of subpaths to access and update the nested value.
  ///   - mapper: The mapper function.
  /// - Returns: The old value found at the end of the paths.
  /// - Throws: If mapping fails.
  private mutating func _map(_ subpaths: [String],
                             _ mapper: (Any?) throws -> Any?) throws -> Any? {
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
        oldValue = try subNest._map(Array(subpaths[1...]), mapper)
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
  ///   - node: The path at which to map.
  ///   - fn: The mapper function.
  /// - Returns: The old value found at the specified node.
  /// - Throws: If mapping fails.
  public mutating func map(at node: String,
                           withMapper fn: (Any?) throws -> Any?) throws -> Any? {
    let nodeComponents = node.components(separatedBy: self.pathSeparator)
    return try self._map(nodeComponents, fn)
  }
  
  /// This method maps, but does not mutate because it returns a new nest.
  ///
  /// - Parameters:
  ///   - node: The path at which to map.
  ///   - fn: The mapper function.
  /// - Returns: A new nest.
  /// - Throws: If mapping fails.
  public func mapping(at node: String,
                      withMapper fn: (Any?) throws -> Any?) throws -> SafeNest {
    var clonedNest = self.cloned()
    _ = try clonedNest.map(at: node, withMapper: fn)
    return clonedNest
  }
}

public extension SafeNest {

  /// Instead of mapping a value, simply replaces it. This method mutates.
  ///
  /// - Parameters:
  ///   - node: The path at which to update.
  ///   - value: The value to update.
  /// - Returns: The old value found at specified node.
  /// - Throws: If updating fails.
  public mutating func update(at node: String, value: Any?) throws -> Any? {
    return try self.map(at: node, withMapper: {_ in value})
  }
  
  /// Updates but does not mutate, instead returns a new nest.
  ///
  /// - Parameters:
  ///   - node: The path at which to update.
  ///   - value: The value to update.
  /// - Returns: A new nest.
  /// - Throws: If updating fails.
  public func updating(at node: String, value: Any?) throws -> SafeNest {
    return try self.mapping(at: node, withMapper: {_ in value})
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
    return try self.update(at: node2, value: copiedValue)
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

public extension SafeNest {

  /// Moves value from one path to another. This method mutates.
  ///
  /// - Parameters:
  ///   - node1: The path at which the moved value is found.
  ///   - node2: The path to move the value to.
  /// - Returns: The old value found at the second node.
  /// - Throws: If moving fails.
  public mutating func move(from node1: String, to node2: String) throws -> Any? {
    let old1 = try self.update(at: node1, value: nil)
    let old2 = try self.update(at: node2, value: old1)
    return old2
  }
  
  /// Moves value from one path to another and return a new nest.
  ///
  /// - Parameters:
  ///   - node1: The path at which the moved value is found.
  ///   - node2: The path to move the value to.
  /// - Returns: A new nest.
  /// - Throws: If moving fails.
  public func moving(from node1: String, to node2: String) throws -> SafeNest {
    var clonedNest = self.cloned()
    _ = try clonedNest.move(from: node1, to: node2)
    return clonedNest
  }
}
