//
//  OPDS2.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 01/05/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation

struct OPDS2AuthenticationDocument: Codable {
    struct Features: Codable {
        let disabled: [String]?
        let enabled: [String]?
    }

    struct Authentication: Codable {
        struct Inputs: Codable {
            struct Input: Codable {
                let barcodeFormat: String?
                let maximumLength: UInt?
                let keyboard: String // TODO: Use enum instead (or not; it could break if new values are added)
            }

            let login: Input
            let password: Input
        }

        struct Labels: Codable {
            let login: String
            let password: String
        }

        let inputs: Inputs?
        let labels: Labels?
        let type: String
        let description: String?
        let links: [OPDS2Link]?
    }

    let features: Features?
    let links: [OPDS2Link]?
    let title: String
    let authentication: [Authentication]?
    let serviceDescription: String?
    let colorScheme: String?
    let id: String

    static func fromData(_ data: Data) throws -> OPDS2AuthenticationDocument {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        return try jsonDecoder.decode(OPDS2AuthenticationDocument.self, from: data)
    }
}
