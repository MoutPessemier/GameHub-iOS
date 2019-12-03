//
//  PartyOverviewViewController.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 30/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import UIKit

class PartyOverviewViewController: UIViewController, NetworkManagerDelegate {
    
    private var networkManager: NetworkManager = NetworkManager()
    private var joinedParties: [Party] = []
    private var games: [Game] = []
    @IBOutlet private var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PartyTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        networkManager.delegate = self
        networkManager.getGames()
        networkManager.getJoinedParties(userId: "5db8838eaffe445c66076a88")
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
            self.tableView.reloadData()
        }
    }
    
    func updateUser(_ networkManager: NetworkManager, _ user: User) {
        fatalError("NotNeededException: This data is not needed in this controller")
    }
    
    func didFail(with error: Error) {
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
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
        cell.partyDate.text = "1/1/1"
        cell.gameName.text = games.first(where: { (game) -> Bool in
            game._id == party.gameId
        })?.name
        return cell
    }
}
