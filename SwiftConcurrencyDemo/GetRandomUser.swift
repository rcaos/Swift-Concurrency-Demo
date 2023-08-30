//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation

#warning("remove it")
func foo() async {
  print("Start download image")
  do {
    let url = URL(string: "https://apod.nasa.gov/apod/image/2308/SeasonSaturnapodacasely.jpg")!
    let (data, _) = try await URLSession.shared.data(from: url)
    print("Bytes: \(ByteCountFormatter().string(fromByteCount: Int64(data.count)))")
  } catch  {
  }
}

public func fetchRandomUser(
  sleep: Int? = nil
) async throws -> User? {
  let randomUserId = Int.random(in: 1...12)
  print("🙅‍♂️ I will Request a random user with ID: \(randomUserId)")
  
  do {
    let url = URL(string: "https://reqres.in/api/users/\(randomUserId)")!
    
    if let sleep {
      try await Task.sleep(for: .seconds(sleep))
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let response = try JSONDecoder().decode(RandomUserResponse.self, from: data)
    print("🙅‍♂️ Random user: \(response)")
    return response.toDomain()
  } catch {
    print("🙅‍♂️ error in fetchRandomUser(): \(error.localizedDescription)")
    throw error
  }
}

public struct User {
  public let id: Int
  public let name: String
  public let email: String
}

// MARK: - Private
private struct RandomUserResponse: Decodable {
  private let data: UserDTO

  private struct UserDTO: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String

    private enum CodingKeys: String, CodingKey {
      case id
      case firstName = "first_name"
      case lastName = "last_name"
      case email
    }
  }

  func toDomain() -> User {
    return .init(
      id: data.id,
      name: data.firstName + " " + data.lastName,
      email: data.email
    )
  }
}
