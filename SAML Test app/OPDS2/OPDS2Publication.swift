//
//  OPDS2Publication.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 01/05/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation

struct OPDS2Publication: Codable {
    struct Metadata: Codable {
        let updated: Date
        let description: String?
        let id: String
        let title: String
    }

    let links: [OPDS2Link]
    let metadata: Metadata
    let images: [OPDS2Link]?
}
