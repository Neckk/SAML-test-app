//
//  AppConfig.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 01/05/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation
import OAuth2

class AppConfig {
    static let exampleBaseURL: URL = URL(string: "https://lyrasis-saml-test.herokuapp.com")!
    static let exampleLoginURL: URL = exampleBaseURL.appendingPathComponent("login").appendingPathComponent("test")

    static func sessionConfiguration(for loginURL: URL) -> OAuth2 {
        let loginURLString = loginURL.absoluteString

        return OAuth2SimplyEGrant(settings: [
            "authorize_uri": loginURLString, // login url, will be provided from auth doc
            "redirect_uris": ["https://skyneck.pl/login"],   // url to call after successfull log in, in this case we use universal link registered to this application
            "keychain_account_for_tokens": loginURLString, // save token under URL key, so that user can log in and store multiple universities sessions
            "keychain": true,
            "client_id": "iOS_app", // Backend may use it for client authentication
//            "client_secret": "some secret", // we may use it in future
//            "scope": "", // we may use it in future
            ] as OAuth2JSON)
    }
}
