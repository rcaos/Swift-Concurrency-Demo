//
//  Created by Jeans Ruiz on 28/08/23.
//

import Foundation

func getNumberFact(_ number: Int) async -> Fact {
  print("🛜 I will Request a fact for the number: \(number)")

  let url = URL(string: "http://numbersapi.com/\(number)/trivia")!
  let factDescription: String

  do {

    try await Task.sleep(for: .seconds(1))

    let (data, _) = try await URLSession.shared.data(from: url)
    factDescription = String(decoding: data, as: UTF8.self)
  } catch {
    factDescription = "\(number) is a good Number"
  }

  print("🛜 Returned: \(factDescription) for the number: \(number)")
  return Fact(number: number, description: factDescription)
}

struct Fact {
  let number: Int
  let description: String
}
