//
//  Created by Jeans Ruiz on 28/08/23.
//

import Foundation

func getNumberFact(
  for number: Int,
  sleep: Int? = nil,
  forceError: Bool = false
) async throws -> Fact {
  print("🛜 I will Request a fact for the number: \(number)")

  let url = forceError ? URL(string: "http://XXX_numbersapi.com/\(number)/trivia")! : URL(string: "http://numbersapi.com/\(number)/trivia")!
  let factDescription: String

  do {

    if let sleep {
      try await Task.sleep(for: .seconds(sleep))
    }
    let (data, response) = try await URLSession.shared.data(from: url)

    if (response as? HTTPURLResponse)?.statusCode == 200 {
      factDescription = String(decoding: data, as: UTF8.self)
    } else {
      throw URLError(.badServerResponse)
    }

  } catch {
    print("🛜 error to getNumberFact(): \(error.localizedDescription)")
    throw error
  }

  print("🛜 Returned: \(factDescription) for the number: \(number)")
  return Fact(number: number, description: factDescription)
}

struct Fact {
  let number: Int
  let description: String
}
