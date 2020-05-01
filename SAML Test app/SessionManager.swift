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
    static var currentSession: SessionManager?

    var loader: OAuth2DataLoader
    var configuration: OAuth2
    let logInURL: String
    let logOutURL: String

    init?(account: Account) {
        guard let logInURL = account.details?.userProfileLogInUrl else { return nil }
        guard let logOutURL = account.details?.userProfileLogOutUrl else { return nil }
        self.logInURL = logInURL
        self.logOutURL = logOutURL

        let oauth2 = AppConfig.sessionConfiguration(for: logInURL)

        // enable trace logging - for debug purpose
        oauth2.logger = OAuth2DebugLogger(.trace)

        self.configuration = oauth2
        self.loader = OAuth2DataLoader(oauth2: configuration)

    }

    func logOut(completionHandler: ((Bool) -> Void)? = nil) {
        guard
            let accessToken = configuration.accessToken,
            let url = URL(string: logOutURL)
            else { completionHandler?(true); return }

        let parameters: [String: Any] = ["token": accessToken]

        // request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // session
        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest, completionHandler: { [configuration] data, response, error in
            guard error == nil else { completionHandler?(false); return }
            guard let data = data else { completionHandler?(false); return }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    configuration.forgetTokens()
                    completionHandler?(true)
                }
            } catch let error {
                print(error.localizedDescription)
                completionHandler?(false)
            }
        })
        task.resume()
    }
}
