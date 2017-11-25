//
//  AppDelegate.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  static var selectedBarIndex = 0

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    requestAuthorisation()
    return true
  }

  func application(_ app: UIApplication, open url: URL,
                   options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
    let string = url.absoluteString
    if string.range(of: "read") != nil {
      AppDelegate.selectedBarIndex = 1
    }
    self.window?.rootViewController
      = mainStoryboad.instantiateViewController(withIdentifier: "MainTabBarViewContoller")
    return true
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    guard let intent = userActivity.interaction?.intent as? INGetVisualCodeIntent else {
      print("AppDelegate: Start Workout Intent - FALSE")
      return false
    }
    print("AppDelegate: Start Workout Intent - TRUE")
    print(intent)

    AppDelegate.selectedBarIndex = 1
    self.window?.rootViewController
      = mainStoryboad.instantiateViewController(withIdentifier: "MainTabBarViewContoller")
    return true
  }

  private func requestAuthorisation() {
    INPreferences.requestSiriAuthorization { status in
      if status == .authorized {
        print("Siri authorized")
      } else {
        print("Siri authorization failed")
      }
    }
  }
}

let mainStoryboad = UIStoryboard(name: "Main", bundle: nil)
