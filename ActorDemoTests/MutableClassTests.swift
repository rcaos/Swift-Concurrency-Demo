//
//  Created by Jeans Ruiz on 21/08/23.
//

import XCTest
import ActorDemo

final class ActorDemoTests: XCTestCase {

  func testCounter() throws {
    let sut = MutableClass()

    DispatchQueue.concurrentPerform(iterations: 1000) { _ in
      sut.increment()
    }

    XCTAssertEqual(sut.counter, 1000)
  }

  func testCounter2() throws {
    let group = DispatchGroup()
    let sut = MutableClass()

    for _ in 0...999 {
      group.enter()

      DispatchQueue.global().async {
        usleep(arc4random() % 1000)
        sut.increment()
        group.leave()
      }
    }

    let result = group.wait(timeout: DispatchTime.now() + 5)
    XCTAssert(result == .success)
    XCTAssertEqual(sut.counter, 1000)
  }

  func testCounter3() async throws {
    let sut = MutableActorClass()

    let expectedValue = 1000

    let tasks = (1...expectedValue).map { index in
      return Task(priority: .random) {
        try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
        try await sut.increment(index)
      }
    }

    for task in tasks {
      try await task.value
    }

    let value = await sut.counter
    XCTAssertEqual(value, expectedValue)
  }
}
