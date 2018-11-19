//
//  Utils.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

public enum SafeNestError: Error, LocalizedError {
  case unsupportedType(obj: Any, path: String)
  
  public var errorDescription: String? {
    switch self {
    case .unsupportedType(let obj, let path):
      return "Unsupported data type \(obj) for path \(path)"
    }
  }
  
  public var localizedDescription: String {
    return self.errorDescription ?? ""
  }
}

func accessObjectPath(_ object: Any, _ path: String) -> Any? {
  if let dict = object as? [String : Any] {
    return dict[path]
  } else if
    let pathInt = Int(path),
    var arr = object as? [Any?],
    pathInt >= 0 && pathInt < arr.count
  {
    return arr[pathInt]
  }
  
  return nil
}

func mapObjectPath(_ obj: Any, _ path: String, _ fn: (Any?) throws -> Any) throws -> Any {
  if var dict = obj as? [String : Any] {
    dict[path] = try fn(dict[path])
    return dict
  } else if let pathInt = Int(path), var arr = obj as? [Any?], pathInt >= 0 {
    if pathInt < arr.count {
      arr[pathInt] = try fn(arr[pathInt])
    } else {
      (arr.count...pathInt).forEach({_ in arr.append(nil as Any?)})
      arr[pathInt] = try fn(arr[pathInt])
    }
    
    return arr
  }
  
  throw SafeNestError.unsupportedType(obj: obj, path: path)
}

func updateObjectPath(_ obj: Any, _ path: String, _ value: Any) throws -> Any {
  return try mapObjectPath(obj, path, {_ in value})
}
