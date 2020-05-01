//
//  OPDS2Link.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 01/05/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import Foundation

struct OPDS2Link: Codable {
    let href: String
    let type: String?
    let rel: String?
    let templated: Bool?
}
