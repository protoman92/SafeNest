//
//  Utils.swift
//  SafeNest
//
//  Created by Hai Pham on 11/19/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SwiftFP

func accessObjectPath(_ object: Any, _ path: String) -> Any? {
  if let dict = object as? [String : Any] {
    return dict[path]
  } else if let pathInt = Int(path), let arr = object as? [Any] {
    return arr[pathInt]
  }
  
  return nil
}

func mapObjectPath(_ obj: Any, _ path: String, _ fn: (Any?) -> Any) -> Any? {
  if var dict = obj as? [String : Any] {
    dict[path] = fn(dict[path])
    return dict
  } else if let pathInt = Int(path), var arr = obj as? [Any] {
    arr[pathInt] = fn(arr[pathInt])
    return arr
  }
  
  return nil
}

func updateObjectPath(_ obj: Any, _ path: String, _ value: Any) -> Any? {
  return mapObjectPath(obj, path, {_ in value})
}
