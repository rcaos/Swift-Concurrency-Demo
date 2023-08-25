//
//  Created by Jeans Ruiz on 22/08/23.
//

import Foundation

public actor MutableActor {
  public var counter = 0

  public init(counter: Int = 0) {
    self.counter = counter
  }

  public func increment(_ index: Int) async throws {
    let currentCount = counter
    counter = currentCount + 1
    print("🚨Counter: \(counter) index Task: \(index)", { Thread.current }())
  }
}
