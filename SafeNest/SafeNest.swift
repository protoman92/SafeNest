//
//  SafeNest.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

public protocol SafeNestType {
  var object: [String : Any] { get }
  var pathSeparator: String { get }
}

struct SafeNest {
  let object: [String : Any]
  let pathSeparator: String
  
  public init(object: [String : Any], pathSeparator: String = ".") {
    self.object = object
    self.pathSeparator = pathSeparator
  }
}

extension SafeNest: SafeNestType {}
