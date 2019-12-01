//
//  NetworkManager.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 30/11/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation

struct NetworkManager {
    let url = "https://game-hub-backend.herokuapp.com/"
    
    // MARK: - Games
    func getGames() -> [Game] {
        let urlString = "\(url)games"
        var games: [Game] = []
        performRequest(urlString: urlString) {data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedGames = try decoder.decode(GamesNetworkContainer.self, from: safeData)
                    games = decodedGames.games
                } catch {
                    print(error)
                }
            }
        }
        // is empty, why?
        return games
    }
    
    // MARK: - Parties
    
    func getPartiesNearYou(maxDistance: Int, userId: String, latitude: Double, longitude: Double) -> [Party] {
        let urlString = "\(url)getPartiesNearYou?distance=\(maxDistance)&lat=\(latitude)&long=\(longitude)&userId=\(userId)"
        var parties: [Party] = []
        performRequest(urlString: urlString) {data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedParties = try decoder.decode(PartiesNetworkContainer.self, from: safeData)
                    parties = decodedParties.parties
                } catch {
                    print(error)
                }
            }
        }
        // is empty, why?
        return parties
    }
    
    // MARK: - User
    
    func getUser(email: String) -> User? {
        let urlString = "\(url)getUserByEmail?email=\(email)"
        var user: User? = nil
        performRequest(urlString: urlString) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedUser = try decoder.decode(User.self, from: safeData)
                    user = decodedUser
                } catch {
                    print(error)
                }
            }
        }
        
        return user
    }
    
    private func performRequest(urlString: String, onCompletionCallback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: onCompletionCallback)
            task.resume()
        }
    }
}
