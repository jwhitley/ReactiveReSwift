//
//  UnsafeMiddleware.swift
//  ReactiveReSwift
//
//  Created by John Whitley on 10/19/17.
//  Copyright © 2017 Benjamin Encz. All rights reserved.
//

public class UnsafeMiddleware<State, Store>: Middleware<State> {
  public typealias GetStore = () -> Store

  var store: Store!
  private lazy var getStore: GetStore = { self.store }

  /// Unsafe middleware with access to the Store
  ///
  /// This should *never* modify the store, but can, thus is marked "unsafe". Yet, some Middleware needs
  /// access to the Store. For example, if UI is to be presented in response to middleware action processing,
  /// that UI usually needs to be initialized with access to the store.
  public func unsafeSideEffect(_ effect: @escaping (Store, @escaping Middleware<State>.DispatchFunction, Action) -> Void) -> Middleware<State> {
    return Middleware<State> { getState, dispatch, action in
      self.transform(getState, dispatch, action).map {
        effect(self.getStore(), dispatch, $0)
        return $0
      }
    }
  }

}
