//
//  CardStackViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 26/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Auth0

class CardStackViewController: UIViewController {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var games: [Game] = []
    private var parties: [Party] = []
    private var user: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        games = networkManager.getGames()
        parties = networkManager.getPartiesNearYou(maxDistance: 10, userId: "5db8838eaffe445c66076a89", latitude: 51.05, longitude: 3.72)
        user = networkManager.getUser(email: "moutpessemier@hotmail.com")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
