//
//  AppDelegate.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 28/04/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            do {
                try SessionManager.currentSession?.configuration.handleRedirectURL(url)
                return true
            }
            catch let error {
                return false
            }
        }

        return false
    }
}
