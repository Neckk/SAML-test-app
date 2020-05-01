//
//  SimplyEGrantType.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 01/05/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation
import OAuth2

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

