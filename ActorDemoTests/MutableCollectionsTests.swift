//
//  Created by Jeans Ruiz on 22/08/23.
//

import Foundation

import XCTest
import SwiftConcurrencyDemo

final class MutableDictionaryTests: XCTestCase {

  func test_Break_Dictionary() throws {
    let sut = MutableCollections()

    let iterations = 1000

    DispatchQueue.concurrentPerform(iterations: iterations) { index in

      sut.increment(key: randomKey() , index)
    }

    XCTAssertEqual(sut.events.count, iterations)
  }

  func test_Break_Dictionary_02() throws {
    let group = DispatchGroup()
    let sut = MutableCollections()

    for index in 1...1000 {
      group.enter()

      DispatchQueue.global().async {
        usleep(arc4random() % 1000)
        sut.increment(key: randomKey(), index)
        group.leave()
      }
    }

    let result = group.wait(timeout: DispatchTime.now() + 5)
    XCTAssert(result == .success)
    XCTAssertEqual(sut.events.count, 1000)
  }

  func test_Break_Array01() throws {
    let sut = MutableCollections()

    let iterations = 1000

    DispatchQueue.concurrentPerform(iterations: iterations) { index in
      sut.add(index)
    }

    XCTAssertEqual(sut.events.count, iterations)
  }

  func test_Break_Array02() throws {
    let group = DispatchGroup()
    let sut = MutableCollections()

    let iterations = 1000

    for index in 1...iterations {
      group.enter()

      DispatchQueue.global().async {
        usleep(arc4random() % 1000)
        sut.add(index)
        group.leave()
      }
    }

    let result = group.wait(timeout: DispatchTime.now() + 5)
    XCTAssert(result == .success)
    XCTAssertEqual(sut.events.count, iterations)
  }
}


public func randomKey() -> String {
  let randomValue = Int.random(in: 1...1_000_000_000_000)
  return "key\(randomValue)"
}
