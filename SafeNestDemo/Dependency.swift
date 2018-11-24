//
//  Dependency.swift
//  SafeNestDemo
//
//  Created by Hai Pham on 11/24/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import SafeNest
import HMReactiveRedux

public final class Redux {
  public static let credentialPath = "cred"
  
  public enum Action: ReduxActionType {
    case changeLoginCredentials(ViewController.State)
  }
  
  public static func reduce(state: SafeNest, action: ReduxActionType) -> SafeNest {
    switch action as? Action {
    case .some(.changeLoginCredentials(let creds)):
      return try! state.encoding(at: Redux.credentialPath, value: creds)
      
    default:
      return state
    }
  }
}

public struct MainDependency {
  private static var _instance: MainDependency?
  
  public static var instance: MainDependency {
    if let instance = self._instance {
      return instance
    } else {
      let initialState = SafeNest.builder().build()
      let store = RxReduxStore.createInstance(initialState, Redux.reduce)
      let instance = MainDependency(store: store)
      self._instance = instance
      return instance
    }
  }
  
  public let store: RxReduxStore<SafeNest>
  
  public init(store: RxReduxStore<SafeNest>) {
    self.store = store
  }
}
