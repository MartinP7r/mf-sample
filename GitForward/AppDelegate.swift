//
//  AppDelegate.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     // swiftlint:disable:next line_length
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: UserListVC())
        return true
    }

    func applicationDidFinishLaunching(_ application: UIApplication) {

    }
}
