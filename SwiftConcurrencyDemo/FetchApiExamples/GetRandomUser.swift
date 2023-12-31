//
//  Created by Jeans Ruiz on 25/08/23.
//

import Foundation

/// Only supports from 1 to 12
public func fetchRandomUser(
  userId: Int? = nil,
  sleep: Int? = nil,
  forceError: Bool = false
) async throws -> User {

  let randomUserId: Int
  if let userId {
    randomUserId = min(userId, 12)
  } else {
    randomUserId = Int.random(in: 1...12)
  }

  print("🙅‍♂️ I will Request a random user with ID: \(randomUserId)")

  do {
    let url = forceError ?
    URL(string: "https://XXX_reqres.in/api/users/\(randomUserId)")! :
    URL(string: "https://reqres.in/api/users/\(randomUserId)")!

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

public struct User: Equatable {
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

// MARK: - Use Case - Convenience
struct RequestFetchUser {
  let userId: Int?
  let sleep: Int?
  let forceError: Bool

  init(userId: Int? = nil, sleep: Int? = nil, forceError: Bool = false) {
    self.userId = userId
    self.sleep = sleep
    self.forceError = forceError
  }
}

struct FetchRandomUser {
  public let execute: @Sendable (_ request: RequestFetchUser) async throws -> User?
}

extension FetchRandomUser {
  static var live: FetchRandomUser {
    return FetchRandomUser(execute: { request in
      return try await fetchRandomUser(userId: request.userId, sleep: request.sleep, forceError: request.forceError)
    })
  }
}
