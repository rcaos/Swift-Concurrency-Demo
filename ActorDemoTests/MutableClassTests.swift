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

    print(sut.counter)
    XCTAssertEqual(sut.counter, 1000)
  }
}
