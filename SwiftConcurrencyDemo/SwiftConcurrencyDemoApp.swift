//
//  ActorDemoApp.swift
//  ActorDemo
//
//  Created by Jeans Ruiz on 21/08/23.
//

import SwiftUI

@main
struct SwiftConcurrencyDemoApp: App {
  var body: some Scene {
    WindowGroup {
      if _XCTIsTesting {
        EmptyView()
      } else {
        RootView()
      }
    }
  }
}
