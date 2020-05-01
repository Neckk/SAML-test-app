//
//  APIMock.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 01/05/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation

class APIMock {
    static let exampleBaseURL: URL = URL(string: "https://lyrasis-saml-test.herokuapp.com")!
    static let exampleLoginURL: URL = exampleBaseURL.appendingPathComponent("login").appendingPathComponent("test")

    static let libraries: OPDS2CatalogsFeed = {
        let fileURL = Bundle.main.url(forResource:"libraries", withExtension: "json")! // szyjson does it load

        do {
            let fileData = try Data(contentsOf: fileURL)
            return try OPDS2CatalogsFeed.fromData(fileData)
        } catch (let error) {
            print("""
                Failed to parse OPDS2Publication document data for URL \(fileURL). Error:
                \(error.localizedDescription)
                """)
            fatalError()
        }
    }()

    static let account: Account = {
        let publication = APIMock.libraries.catalogs.first!
        let account = Account(publication: publication)
        account.loadAuthenticationDocument { _ in } // is synchronous, modified it to load content from file
        return account
    }()
}
