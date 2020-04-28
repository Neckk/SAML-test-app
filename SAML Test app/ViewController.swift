//
//  ViewController.swift
//  SAML Test app
//
//  Created by Jacek Szyja on 28/04/2020.
//  Copyright © 2020 Jacek Szyja. All rights reserved.
//

import UIKit
import OAuth2

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        oauthTest()
    }

    func oauthTest() {
        SessionManager.shared.configuration.authConfig.authorizeContext = self
        // request data
        let base = URL(string: "https://lyrasis-saml-test.herokuapp.com")!
        let url = base.appendingPathComponent("me")

        var req = SessionManager.shared.configuration.request(forURL: url)

        SessionManager.shared.loader?.perform(request: req) { response in
            do {
                let dict = try response.responseJSON()
                print("Oauth Received \(dict)")
//                DispatchQueue.main.async {
//                    // you have received `dict` JSON data!
//                }
            }
            catch let error {
                print("Oauth Error \(error)")
//                DispatchQueue.main.async {
//                    // an error occurred
//                }
            }
        }

    }
}
