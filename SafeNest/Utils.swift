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
