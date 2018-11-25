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
  public typealias State = SafeNest
  public typealias Action = ReduxActionType
  public static let credentialPath = "cred"
  
  public enum CredentialAction: Action {
    case changeLoginCredentials(ViewController.State)
  }
  
  public static func reduce(state: State, action: Action) -> State {
    do {
      switch action as? CredentialAction {
      case .some(.changeLoginCredentials(let creds)):
        return try state.encoding(at: Redux.credentialPath, value: creds)
        
      default:
        return state
      }
    } catch (let e) {
      fatalError(e.localizedDescription)
    }
  }
}

public struct MainDependency {
  private static var _instance: MainDependency?
  
  public static var instance: MainDependency {
    if let instance = self._instance {
      return instance
    } else {
      let store = RxReduxStore.create(SafeNest.empty(), Redux.reduce)
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
