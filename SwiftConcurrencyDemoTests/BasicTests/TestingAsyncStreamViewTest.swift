//
//  Created by Jeans Ruiz on 4/09/23.
//

import Foundation

import XCTest
import ConcurrencyExtras
@testable import SwiftConcurrencyDemo

final class TestingAsyncStreamViewTest: XCTestCase {

  override func invokeTest() {
    withMainSerialExecutor {
      super.invokeTest()
    }
  }

  func test_When_Zero_ScreenShots_taken_Should_show_Initial_State() async {

    let sut = TestingAsyncStreamModel()

    _ = Task {
      await sut.onTask()
    }
    await Task.yield()

    XCTAssertNil(sut.message)
    XCTAssertNil(sut.messageCounter)
  }

  func test_When_1_ScreenShot_taken_Should_show_Message() async {

    let sut = TestingAsyncStreamModel()

    _ = Task {
      await sut.onTask()
    }
    await Task.yield()
    await NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)

    await Task.yield()

    XCTAssertNil(sut.message)
    XCTAssertEqual(sut.messageCounter, "You took 1 snapshot so far")
  }

  func test_When_2_ScreenShots_taken_Should_show_Message() async {

    let sut = TestingAsyncStreamModel()

    _ = Task {
      await sut.onTask()
    }
    await Task.yield()
    
    for _ in 1...2 {
      await NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
      await Task.yield()
    }

    XCTAssertNil(sut.message)
    XCTAssertEqual(sut.messageCounter, "You already took 2 snapshots so far")
  }

  func test_When_5_ScreenShots_taken_Should_show_Message() async {

    let sut = TestingAsyncStreamModel()

    _ = Task {
      await sut.onTask()
    }
    await Task.yield()

    for _ in 1...5 {
      await NotificationCenter.default.post(name: UIApplication.userDidTakeScreenshotNotification, object: nil)
      await Task.yield()
    }

    XCTAssertEqual(sut.message, "Why are you taking to many screenshots?")
    XCTAssertEqual(sut.messageCounter, "You already took 5 snapshots so far")
  }
}
