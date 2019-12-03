//
//  NetworkManager.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 30/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate {
    func updateGames(_ networkManager: NetworkManager, _ games: [Game])
    func updateParties(_ networkManager: NetworkManager, _ parties: [Party])
    func updateUser(_ networkManager: NetworkManager, _ user: User)
    func didFail(with error: Error)
}

struct NetworkManager {
    let url = "https://game-hub-backend.herokuapp.com/"
    
    var delegate: NetworkManagerDelegate?
    
    // MARK: - Games
    func getGames() {
        let urlString = "\(url)games"
        performRequest(with: urlString) {data, response, error in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedContainer = try decoder.decode(GamesNetworkContainer.self, from: safeData)
                    self.delegate?.updateGames(self, decodedContainer.games)
                } catch {
                    self.delegate?.didFail(with: error)
                }
            }
        }
    }
    
    // MARK: - Parties
    
    func getPartiesNearYou(maxDistance: Int, userId: String, latitude: Double, longitude: Double) {
        let urlString = "\(url)getPartiesNearYou?distance=\(maxDistance)&lat=\(latitude)&long=\(longitude)&userId=\(userId)"
        print("URL", urlString)
        performRequest(with: urlString) {data, response, error in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                do {
                    let decodedContainer = try decoder.decode(PartiesNetworkContainer.self, from: safeData)
                    self.delegate?.updateParties(self, decodedContainer.parties)
                } catch {
                    self.delegate?.didFail(with: error)
                }
            }
        }
    }
    
    func getJoinedParties(userId: String) {
        let urlString = "\(url)getJoinedParties?userId=\(userId)"
        performRequest(with: urlString) { (data, response, error) in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedContainer = try decoder.decode(PartiesNetworkContainer.self, from: safeData)
                    self.delegate?.updateParties(self, decodedContainer.parties)
                } catch {
                    self.delegate?.didFail(with: error)
                }
            }
        }
    }
    
    // MARK: - User
    
    func getUser(email: String) {
        let urlString = "\(url)getUserByEmail?email=\(email)"
        performRequest(with: urlString) { data, response, error in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedUser = try decoder.decode(User.self, from: safeData)
                    self.delegate?.updateUser(self, decodedUser)
                } catch {
                    self.delegate?.didFail(with: error)
                }
            }
        }
    }
    
    private func performRequest(with urlString: String, onCompletionCallback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: onCompletionCallback)
            task.resume()
        }
    }
}
