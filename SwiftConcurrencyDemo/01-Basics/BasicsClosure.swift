//
//  Created by Jeans Ruiz on 26/08/23.
//

import Foundation
import SwiftUI
import NotificationCenter
import CoreLocation

struct Basic02View: View {

  var model = Basics02Model()

  var body: some View {
    Section {
      Button("👉 Get Device Permissions", action: {
        Task {
          await model.getRandomUser()
        }
      })
      .padding()

      if model.isRequestOnFlight {
        ProgressView()
      }

      if let permissions = model.devicePermissions {
        Text("Push Notifications Permissions: \(description(for: permissions.notificationStatus))")
        Text("Location Permissions: \(description(for: permissions.locationStatus))")
      }
    }
    .padding([.top])

    Spacer()
  }
}

@Observable class Basics02Model {

  var isRequestOnFlight = false
  var devicePermissions: DevicePermissions?

  func getRandomUser() async {
    devicePermissions = nil

    do {
      isRequestOnFlight = true
      try await Task.sleep(nanoseconds: 1_000_000_000)

      /// Step 02: Now you can use ``await``
      /// The previous implementation was based on Closures
      devicePermissions = await notificationSettings()

      isRequestOnFlight = false
    } catch {
      isRequestOnFlight = false
    }
  }

  deinit {
    print("deinit: \(Self.self)")
  }
}

struct DevicePermissions {
  let notificationStatus: UNAuthorizationStatus
  let locationStatus: CLAuthorizationStatus
}

@available(*, deprecated, message: "Use Async version instead, Don't remove yet this cose is use in many places")
func getNotificationSettings(completion: @escaping (DevicePermissions) -> Void ) {
  UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {
    completion(
      DevicePermissions(
        notificationStatus: $0.authorizationStatus,
        locationStatus: CLLocationManager().authorizationStatus
      )
    )
  })
}

func notificationSettings() async -> DevicePermissions {
  /// Step 01: Use ``withCheckedContinuation`` to wrap a closure implementation

  return await withCheckedContinuation { continuation in
    getNotificationSettings {
      continuation.resume(returning: $0)
    }
  }
}

func description(for authorizationStatus: UNAuthorizationStatus) -> String {
  switch authorizationStatus {
  case .authorized:
    return "authorized"
  case .denied:
    return "denied"
  case .provisional:
    return "provisional"
  case .ephemeral:
    return "ephemeral"
  case .notDetermined:
    return "notDetermined"
  @unknown default:
    return "unknown"
  }
}

func description(for locationStatus: CLAuthorizationStatus) -> String {
  switch locationStatus {
  case .notDetermined:
    return "notDetermined"
  case .restricted:
    return "restricted"
  case .denied:
    return "denied"
  case .authorizedAlways:
    return "authorizedAlways"
  case .authorizedWhenInUse:
    return "authorizedWhenInUse"
  case .authorized:
    return "authorized"
  @unknown default:
    return "unknown"
  }
}

#Preview {
  Basic02View()
}
