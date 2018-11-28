//
//  Utils.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

public enum SafeNestError: Error, LocalizedError {
  case notArrayCompatible(obj: Any?)
  case unsupportedType(obj: Any?, path: String)
  
  public var errorDescription: String? {
    return self.localizedDescription
  }
  
  public var localizedDescription: String {
    switch self {
    case .notArrayCompatible(let obj):
      return "\(String(describing: obj)) is not Array-compatible"
      
    case .unsupportedType(let obj, let path):
      return "Unsupported data type \(String(describing: obj)) for path \(path)"
    }
  }
}

func accessObjectPath(_ object: Any?, _ path: String) -> Any? {
  if path != "" {
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
  
  return object
}

func mapObjectPath(_ obj: Any?, _ path: String, _ fn: (Any?) throws -> Any?) throws
  -> (newObject: Any?, oldValue: Any?)
{
  if path != "" {
    if var dict = obj as? [String : Any] {
      let oldValue = dict[path]
      dict[path] = try fn(oldValue)
      return (dict, oldValue)
    } else if let pathInt = Int(path), var arr = obj as? [Any?], pathInt >= 0 {
      if pathInt >= arr.count {
        (arr.count...pathInt).forEach({_ in arr.append(nil as Any?)})
      }
      
      let oldValue = arr[pathInt]
      arr[pathInt] = try fn(oldValue)
      return (arr, oldValue)
    }
    
    throw SafeNestError.unsupportedType(obj: obj, path: path)
  }
  
  return try (fn(obj), obj)
}

func updateObjectPath(_ obj: Any?, _ path: String, _ value: Any?) throws
  -> (newObject: Any?, oldValue: Any?) {
  return try mapObjectPath(obj, path, {_ in value})
}

func extractArray<T>(_ obj: Any?, _ ofType: T.Type) throws -> [T] {
  if let dict = obj as? [String : T] {
    return Array(dict.values)
  } else if let array = obj as? [T] {
    return array
  }
  
  throw SafeNestError.notArrayCompatible(obj: obj)
}
