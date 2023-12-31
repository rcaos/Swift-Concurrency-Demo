//
//  Created by Jeans Ruiz on 21/08/23.
//

import XCTest
import SwiftConcurrencyDemo

#warning("All these tests will always fail")
final class MutableClassTests: XCTestCase {

  func testBreakCounter() throws {
    let sut = MutableClass()

    DispatchQueue.concurrentPerform(iterations: 1000) { index in
      sut.increment(index)
    }

    XCTAssertEqual(sut.counter, 1000)
  }

  func testBreakCounter2() throws {
    let group = DispatchGroup()
    let sut = MutableClass()

    for index in 0...999 {
      group.enter()

      DispatchQueue.global().async {
        usleep(arc4random() % 1000)
        sut.increment(index)
        group.leave()
      }
    }

    let result = group.wait(timeout: DispatchTime.now() + 5)
    XCTAssert(result == .success)
    XCTAssertEqual(sut.counter, 1000)
  }

  func testBreakCounter3() async throws {
    let sut = MutableClass()

    let expectedValue = 1000

    let tasks = (1...expectedValue).map { index in
      return Task(priority: .random) {
        try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
        sut.increment(index)
      }
    }

    for task in tasks {
      try await task.value
    }

    let value = sut.counter
    XCTAssertEqual(value, expectedValue)
  }

  func testBreakCounter4() async throws {
    let expectedValue = 1000

    let sut = MutableClass()

    _ = await withThrowingTaskGroup(of: Int.self) { group in
      for index in 1...expectedValue {
        group.addTask {
          try await Task.sleep(nanoseconds: UInt64(arc4random() % 1000) )
          sut.increment(index)
          return index
        }
      }
    }

    let value = sut.counter
    XCTAssertEqual(value, expectedValue)
  }
}
