//
//  SessionManager.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 28/04/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation
import OAuth2

class SessionManager {
    static let shared: SessionManager = SessionManager(configuration: defaultConfiguration())!

    var loader: OAuth2DataLoader?
    var configuration: OAuth2

    init?(configuration: OAuth2) {
        self.configuration = configuration
        self.loader = OAuth2DataLoader(oauth2: configuration)
    }

    static func defaultConfiguration() -> OAuth2 {
        let oauth2 = OAuth2SimplyEGrant(settings: [
            "client_id": "iOS_app",
//            "client_secret": "C7447242",
            "authorize_uri": "https://lyrasis-saml-test.herokuapp.com/login/test",
            "redirect_uris": ["https://skyneck.pl/login"],   // register your own "myapp" scheme in Info.plist
            "scope": "",
            "secret_in_body": false,    // Github needs this
            "keychain": false,         // if you DON'T want keychain integration
            ] as OAuth2JSON)

        // enable trace logging
        oauth2.logger = OAuth2DebugLogger(.trace)

        // open login in embedded browser
        oauth2.authConfig.authorizeEmbedded = true
//        oauth2.authConfig.authorizeContext = self
        oauth2.authConfig.authorizeEmbeddedAutoDismiss = true
        return oauth2
    }
}

/**
 Class to handle OAuth2 requests for public clients, such as distributed Mac/iOS Apps.
 */
open class OAuth2SimplyEGrant: OAuth2ImplicitGrant {

    /// disable token_type veriffication, won't be necessary if backend responds `token_type=bearer`
    open override func assureCorrectBearerType(_ params: OAuth2JSON) throws {
    }

    /// disable state veriffication, won't be necessary if backend responds with `state=<state received in initial request>`
    open override func assureAccessTokenParamsAreValid(_ params: OAuth2JSON) throws {
    }

    /// backend returns token inside `token` query item
    open override func normalizeAccessTokenResponseKeys(_ dict: OAuth2JSON) -> OAuth2JSON {
        var dict = dict
        dict["access_token"] = dict["token"]
        return dict
    }

    override open func handleRedirectURL(_ redirect: URL) {
        logger?.debug("OAuth2", msg: "Handling redirect URL \(redirect.description)")
        do {
            // token should be in the URL fragment
            let comp = URLComponents(url: redirect, resolvingAgainstBaseURL: true)
            guard let queryItems = comp?.queryItems, queryItems.count > 0 else {
                throw OAuth2Error.invalidRedirectURL(redirect.description)
            }

            let params = queryItems.reduce(into: OAuth2JSON()) { (result, item) in
                guard let value = item.value else { return }
                result[item.name] = value
            }

            let dict = try parseAccessTokenResponse(params: params)
            logger?.debug("OAuth2", msg: "Successfully extracted access token")
            didAuthorize(withParameters: dict)
        }
        catch let error {
            didFail(with: error.asOAuth2Error)
        }
    }
}

