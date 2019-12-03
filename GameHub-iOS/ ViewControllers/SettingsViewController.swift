//
//  SettingsViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 03/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Auth0
import Loaf

class SettingsViewController: UIViewController {
    
    @IBOutlet var btnLogout: UIButton!
    var isAuthenticated = true
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        Auth0
            .webAuth()
            .clearSession(federated:false){
                switch $0{
                case true:
                    DispatchQueue.main.async {
                        self.isAuthenticated = false
                        self.performSegue(withIdentifier: "logout", sender: self)
                    }
                case false:
                    DispatchQueue.main.async {
                        Loaf("Something went wrong, please try again!", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    }
                }
        }
    }
}
