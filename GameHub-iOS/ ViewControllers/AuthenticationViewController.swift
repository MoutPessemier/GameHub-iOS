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

class AuthenticationViewController: UIViewController, NetworkManagerDelegate {
    private let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    private var networkManager = NetworkManager()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
    }
    
    // MARK: - Auth0
    @IBAction func showLogin(_ sender: Any) {
        login()
    }
    
    private func login() {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        Auth0
            .webAuth()
            .scope("openid profile read:current_user")
            .audience("https://" + clientInfo.domain + "/api/v2/")
            .start { (result) in
                switch result {
                case .failure(let error):
                    print("---WEBAUTH---", error)
                case .success(let credentials):
                    if(!SessionManager.shared.store(credentials: credentials)) {
                        print("Failed to store credentials")
                    } else {
                        SessionManager.shared.retrieveProfile { error in
                            DispatchQueue.main.async {
                                guard error == nil else {
                                    print("Failed to retrieve profile: \(String(describing: error))")
                                    return self.login()
                                }
                                SessionManager.shared.getMetaData { (error) in
                                    if let error = error {
                                        print("---GETMETADATA---", error)
                                    }
                                    self.networkManager.doesUserExist(email: SessionManager.shared.profile!.name!)
                                }
                            }
                        }
                    }
                }
        }
    }
    
    // MARK: - NetworkDelegate
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        SessionManager.shared.user = user
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "authenticate", sender: self)
        }
    }
    
    func doesUserExist(_ networkManager: NetworkManager, _ userExists: Bool) {
        let email = SessionManager.shared.profile!.name!
        if userExists {
            let loginDTO = LoginDTO(email: email)
            networkManager.login(loginDTO: loginDTO)
        } else {
            let firstName = SessionManager.shared.metadata!["fname"]! as! String
            let lastName = SessionManager.shared.metadata!["lname"]! as! String
            let registerDTO = RegisterDTO(firstName: firstName, lastName: lastName, email: email)
            networkManager.register(registerDTO: registerDTO)
        }
    }
    
    func didFail(with error: Error) {
        print("---DIDFAIL AT AUTHENTICATION", error)
    }
    
    // MARK: - Unwind
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    }
}

private func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
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
