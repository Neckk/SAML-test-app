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

    let account = APIMock.account

    let currentSession: SessionManager! = SessionManager(account: APIMock.account)

    @IBOutlet var loadButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureOauthSession()
        prepareUI()
    }

    private func configureOauthSession() {
        // configure oauth login to present in embeded web view
        currentSession.configuration.authConfig.authorizeEmbedded = true
        currentSession.configuration.authConfig.authorizeEmbeddedAutoDismiss = true
        currentSession.configuration.authConfig.authorizeContext = self

        // set it as a current session, so that AppDelegate can inform it about universal link redirect
        SessionManager.currentSession = currentSession
    }

    private func prepareUI() {
        logOutButton.isEnabled = currentSession.configuration.hasUnexpiredAccessToken()
    }

    @IBAction func loadContentAction(_ sender: Any) {
        let url = APIMock.exampleBaseURL.appendingPathComponent("me")

        let req = currentSession.configuration.request(forURL: url)

        currentSession.loader.perform(request: req) { [weak self] response in
            do {
                _ = try response.responseJSON() // check if data is parsable, no need to use it in this example though
                DispatchQueue.main.async { [weak self] in
                    self?.logOutButton.isEnabled = true
                    self?.textLabel.text = response.data?.prettyPrintedJSONString as String?
                }
            }
            catch let error {
                DispatchQueue.main.async { [weak self] in
                    self?.logOutButton.isEnabled = false
                    self?.textLabel.text = error.localizedDescription
                }
            }
        }
    }

    @IBAction func logOutAction(_ sender: Any) {
        currentSession.logOut { [weak self] success in
            DispatchQueue.main.async { [weak self] in
                self?.textLabel.text = "Log out successfull"
                self?.logOutButton.isEnabled = !success
            }
        }
    }

}
