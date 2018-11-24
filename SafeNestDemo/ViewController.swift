//
//  ViewController.swift
//  SafeNestDemo
//
//  Created by Hai Pham on 11/24/18.
//  Copyright © 2018 swiften. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftFP
import UIKit

public final class ViewController: UIViewController {
  @IBOutlet private weak var firstNameInput: UITextField!
  @IBOutlet private weak var lastNameInput: UITextField!
  @IBOutlet private weak var passwordInput: UITextField!
  private lazy var disposeBag: DisposeBag = DisposeBag()
  
  public var dependency: Dependency? {
    get {
      return nil
    }
    
    set {
      if let dependency = newValue {
        self.setupDependency(dependency)
      }
    }
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Login"
  }
  
  private func setupDependency(_ dependency: Dependency) {
    guard
      let firstNameInput = self.firstNameInput,
      let lastNameInput = self.lastNameInput,
      let passwordInput = self.passwordInput
      else {
        fatalError()
    }
    
    let stateStream = dependency.stateStream.share(replay: 1)
    
    stateStream
      .map({$0.firstName})
      .subscribe(firstNameInput.rx.text)
      .disposed(by: self.disposeBag)
    
    stateStream
      .map({$0.lastName})
      .subscribe(lastNameInput.rx.text)
      .disposed(by: self.disposeBag)
    
    stateStream
      .map({$0.password})
      .subscribe(passwordInput.rx.text)
      .disposed(by: self.disposeBag)
    
    Observable
      .combineLatest(
        firstNameInput.rx.text.asObservable(),
        lastNameInput.rx.text.asObservable(),
        passwordInput.rx.text.asObservable()
      )
      .map({State(firstName: $0, lastName: $1, password: $2)})
      .subscribe(dependency.credentialsReceiver)
      .disposed(by: self.disposeBag)
  }
}

public extension ViewController {
  public struct State {
    public let firstName: String?
    public let lastName: String?
    public let password: String?
  }
  
  public struct Dependency {
    public let stateStream: Observable<State>
    public let credentialsReceiver: AnyObserver<State>
    
    public init(stateStream: Observable<State>,
                credentialsReceiver: AnyObserver<State>) {
      self.stateStream = stateStream
      self.credentialsReceiver = credentialsReceiver
    }
  }
}

extension ViewController.State: Encodable {}
extension ViewController.State: Decodable {}
extension ViewController.State: Equatable {}

public protocol ViewControllerDependencyFactory {
  func dependencyForViewController() -> ViewController.Dependency
}
