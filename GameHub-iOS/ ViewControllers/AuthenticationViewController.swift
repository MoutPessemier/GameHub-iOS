//
//  AuthenticationViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 30/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Auth0
import Loaf

class AuthenticationViewController: UIViewController {
    private var isAuthenticated = false
    private static var amountVisited: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AuthenticationViewController.amountVisited == 1 {
            Loaf("Successful logout", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            AuthenticationViewController.amountVisited += 1
        }
    }
    
    @IBAction func showLogin(_ sender: UIButton) {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://" + clientInfo.domain + "/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    Loaf("Something went wrong, please try again!", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    print("Error: \(error)")
                case .success(let credentials):
                    guard let accessToken = credentials.accessToken else { return }
                    //send accestoken to get user info back
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.performSegue(withIdentifier: "authenticate", sender: self)
                        
                    }
                }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }
    
    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain)
}
