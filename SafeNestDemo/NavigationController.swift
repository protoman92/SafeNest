//
//  NavigationController.swift
//  SafeNestDemo
//
//  Created by Hai Pham on 11/24/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import UIKit

public final class NavigationController: UINavigationController {
  private var dependency: Dependency?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.dependency = Dependency(dependency: MainDependency.instance)
  }
}

extension NavigationController: UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController,
                                   willShow viewController: UIViewController,
                                   animated: Bool) {
    switch viewController {
    case let vc as ViewController:
      vc.dependency = self.dependency!.dependencyForViewController()
      
    default:
      fatalError("Unexpected view controller \(viewController)")
    }
  }
}

public extension NavigationController {
  public struct Dependency {
    private let dependency: MainDependency
    
    public init(dependency: MainDependency) {
      self.dependency = dependency
    }
  }
}

extension NavigationController.Dependency: ViewControllerDependencyFactory {
  public func dependencyForViewController() -> ViewController.Dependency {
    return ViewController.Dependency(
      stateStream: self.dependency.store
        .stateStream
        .map({$0.decode(at: Redux.credentialPath, ofType: ViewController.State.self)})
        .filter({$0.value != nil})
        .map({try $0.getOrThrow()})
        .distinctUntilChanged(),
      credentialsReceiver: self.dependency.store
        .actionTrigger
        .mapObserver(Redux.CredentialAction.changeLoginCredentials)
    )
  }
}
