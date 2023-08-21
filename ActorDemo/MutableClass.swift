//
//  Created by Jeans Ruiz on 21/08/23.
//

import Foundation

public class MutableClass {
  public var counter = 0

  public init(counter: Int = 0) {
    self.counter = counter
  }

  public func increment() {
    let currentCount = counter
    counter = currentCount + 1
  }
}
