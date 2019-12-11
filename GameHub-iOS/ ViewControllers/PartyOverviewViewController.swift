//
//  PartyOverviewViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 30/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit
import Lottie

class PartyOverviewViewController: UIViewController, NetworkManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var joinedParties: [Party] = []
    private var games: [Game] = []
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var animationView: AnimationView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PartyTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        networkManager.delegate = self
        networkManager.getGames()
        networkManager.getJoinedParties(userId: "5db8838eaffe445c66076a88")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let animation = Animation.named("loading_infinity") {
            animationView.animation = animation
            animationView.loopMode = .loop
            animationView.play()
        }
    }
    
    // MARK: - Network Delegate
    func updateGames(_ networkManager: NetworkManager, _ games: [Game]) {
        self.games = games
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party]) {
        self.joinedParties = parties
        DispatchQueue.main.async {
            self.animationView.animation = nil
            self.animationView.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        fatalError("NotNeededException: This data is not needed in this controller")
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
        print("---DIDFAIL WITH ERROR @ PARTYOVERVIEW", error.localizedDescription, error)
    }
}

// MARK: - Table view data source
extension PartyOverviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedParties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PartyTableViewCell
        let party: Party = joinedParties[indexPath.row]
        cell.partyName.text = party.name
        cell.partyDate.text = getSimpleDate(party.date.iso8601)
        cell.gameName.text = games.first(where: { (game) -> Bool in
            game.id == party.gameId
        })?.name
        return cell
    }
}

// MARK: - Helpers
private func getSimpleDate(_ dateString: String) -> String {
    let dateArray = dateString.split { $0 == "T" }
    let date: String = String(dateArray[0]).replacingOccurrences(of: "-", with: "/")
    return date
}
