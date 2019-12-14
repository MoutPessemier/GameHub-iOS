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
import Lottie

class SettingsViewController: UIViewController, NetworkManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var loggedInUser = SessionManager.shared.user!
    
    @IBOutlet private var animationView: AnimationView!
    @IBOutlet private var txtFirstName: UITextField!
    @IBOutlet private var txtLastName: UITextField!
    @IBOutlet private var txtEmail: UITextField!
    @IBOutlet private var distanceSlider: UISlider!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSettings(loggedInUser)
    }
    
    // MARK: - Auth0
    @IBAction private func logout(_ sender: Any) {
//        Auth0
//            .webAuth()
//            .clearSession(federated:false){
//                switch $0{
//                case true:
//                    SessionManager.shared.logout { (error) in
//                        if let error = error {
//                            print("---LOGOUT---", error, error.localizedDescription)
//                            DispatchQueue.main.async {
//                                Loaf.init("Something went wrong, try again!", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
//                            }
//                        }
//                        DispatchQueue.main.async {
//                            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
//                        }
//                    }
//                case false:
//                    DispatchQueue.main.async {
//                        Loaf("Something went wrong, please try again!", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
//                    }
//                }
//        }
    }
    
    @IBAction private func saveChanges(_ sender: Any) {
        guard let firstName = txtFirstName.text else { return }
        guard let lastName = txtLastName.text else { return }
        guard let email = txtEmail.text else { return }
        let distance = distanceSlider.value
        
        loggedInUser.email = email
        loggedInUser.maxDistance = Int(distance)
        loggedInUser.firstName = firstName
        loggedInUser.lastName = lastName
        networkManager.updateUser(user: loggedInUser)
        updateSettings(loggedInUser)
    }
    
    // MARK: - NetworkDelegates
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func doesUserExist(_ networkManager: NetworkManager, _ userExists: Bool) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        self.loggedInUser = user
        DispatchQueue.main.async {
            self.animationView.isHidden = true
            self.animationView.animation = nil
            self.updateSettings(user)
        }
    }
    
    func didFail(with error: Error) {
        DispatchQueue.main.async {
            if let animation = Animation.named("error") {
                self.animationView.isHidden = false
                self.animationView.animation = animation
                self.animationView.loopMode = .repeat(3.0)
                self.animationView.play { (finished) in
                    self.animationView.stop()
                    self.animationView.isHidden = true
                }
            }
        }
        print("---DIDFAIL WITH ERROR @ SETTINGS---", error.localizedDescription)
    }
    
    // MARK: - Helpers
    private func updateSettings(_ user: User){
        txtFirstName.text = user.firstName
        txtLastName.text = user.lastName
        txtEmail.text = user.email
        distanceSlider.value = Float(user.maxDistance)
    }
}
