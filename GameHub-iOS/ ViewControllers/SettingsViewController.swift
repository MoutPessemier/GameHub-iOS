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
    
    private var isAuthenticated = true
    private var loggedInUser: User? = nil
    private var networkManager: NetworkManager = NetworkManager()
    @IBOutlet private var animationView: AnimationView!
    @IBOutlet private var txtFirstName: UITextField!
    @IBOutlet private var txtLastName: UITextField!
    @IBOutlet private var txtEmail: UITextField!
    @IBOutlet private var distanceSlider: UISlider!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.delegate = self
        networkManager.getUser(email: "moutpessemier@hotmail.com")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let animation = Animation.named("loading_infinity") {
            animationView.animation = animation
            animationView.loopMode = .loop
            animationView.play()
        }
    }
    
    // MARK: - Auth0
    @IBAction private func logout(_ sender: Any) {
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
    
    @IBAction private func saveChanges(_ sender: Any) {
        guard let firstName = txtFirstName.text else { return }
        guard let lastName = txtLastName.text else { return }
        guard let email = txtEmail.text else { return }
        let distance = distanceSlider.value
        
        guard var user = loggedInUser else  { return }
        
        user.email = email
        user.maxDistance = Int(distance)
        user.firstName = firstName
        user.lastName = lastName
        networkManager.updateUser(user: user)
        updateSettings(user)
    }
    
    // MARK: - NetworkDelegates
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
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
                self.animationView.play { (finished) in self.animationView.stop() }
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
