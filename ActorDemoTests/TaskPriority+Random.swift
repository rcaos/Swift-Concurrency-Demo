//
//  Created by Jeans Ruiz on 22/08/23.
//

import Foundation

extension TaskPriority {
  static var random: TaskPriority {
    let randomValue = (Int.random(in: 1...100) % 2) == 0
    if randomValue {
      return .low
    } else {
      return .high
    }
  }
}
