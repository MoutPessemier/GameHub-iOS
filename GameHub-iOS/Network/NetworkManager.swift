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
    func doesUserExist(_ networkManager: NetworkManager, _ userExists: Bool)
    func didFail(with error: Error)
}

struct NetworkManager {
    let url = "https://game-hub-backend.herokuapp.com/"
    
    var delegate: NetworkManagerDelegate?
    
    // MARK: - Games
    func getGames() {
        let urlString = "\(url)games"
        performGetRequest(with: urlString) {data, response, error in
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
        performGetRequest(with: urlString) {data, response, error in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
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
        performGetRequest(with: urlString) { (data, response, error) in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                do {
                    let decodedContainer = try decoder.decode(PartiesNetworkContainer.self, from: safeData)
                    self.delegate?.updateParties(self, decodedContainer.parties)
                } catch {
                    self.delegate?.didFail(with: error)
                }
            }
        }
    }
    
    func joinParty(partyId: String, userId: String) {
        let urlString = "\(url)joinParty"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601withFractionalSeconds
        let partyIdentifier = PartyIdentifierDTO(partyId: partyId, userId: userId)
        do {
            let encodedData = try encoder.encode(partyIdentifier)
            performPostRequest(with: urlString, body: encodedData) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(with: error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                    do {
                        let _ = try decoder.decode(Party.self, from: safeData)
                    } catch {
                        self.delegate?.didFail(with: error)
                    }
                }
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func declineParty(partyId: String, userId: String) {
        let urlString = "\(url)declineParty"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601withFractionalSeconds
        let partyIdentifier = PartyIdentifierDTO(partyId: partyId, userId: userId)
        do {
            let encodedData = try encoder.encode(partyIdentifier)
            performPostRequest(with: urlString, body: encodedData) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(with: error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                    do {
                        let _ = try decoder.decode(Party.self, from: safeData)
                    } catch {
                        self.delegate?.didFail(with: error)
                    }
                }
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    // MARK: - User
    
    func doesUserExist(email: String) {
        let urlString = "\(url)doesUserExist?email=\(email)"
        performGetRequest(with: urlString) { (data, response, error) in
            if error != nil {
                self.delegate?.didFail(with: error!)
                return
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedBoolean = try decoder.decode(Bool.self, from: safeData)
                    self.delegate?.doesUserExist(self, decodedBoolean)
                } catch {
                    self.delegate?.didFail(with: error)
                }
            }
        }
    }
    
    func getUser(email: String) {
        let urlString = "\(url)getUserByEmail?email=\(email)"
        performGetRequest(with: urlString) { data, response, error in
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
    
    func updateUser(user: User) {
        let urlString = "\(url)updateUser"
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(user)
            performPutRequest(with: urlString, body: encodedData) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(with: error!)
                    return
                }
                if let safeData = data {
                    let decoder  = JSONDecoder()
                    do {
                        let decodedUserContainer = try decoder.decode(UserNetworkContainer.self, from: safeData)
                        self.delegate?.updateUser(self, decodedUserContainer.user)
                    } catch {
                        self.delegate?.didFail(with: error)
                    }
                }
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func register(registerDTO: RegisterDTO) {
        let urlString = "\(url)register"
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(registerDTO)
            performPostRequest(with: urlString, body: encodedData) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(with: error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedUserContainer = try decoder.decode(UserNetworkContainer.self, from: safeData)
                        self.delegate?.updateUser(self, decodedUserContainer.user)
                    } catch {
                        self.delegate?.didFail(with: error)
                    }
                }
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    func login(loginDTO: LoginDTO) {
        let urlString = "\(url)login"
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(loginDTO)
            performPostRequest(with: urlString, body: encodedData) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFail(with: error!)
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedUserContainer = try decoder.decode(UserNetworkContainer.self, from: safeData)
                        self.delegate?.updateUser(self, decodedUserContainer.user)
                    } catch {
                        self.delegate?.didFail(with: error)
                    }
                }
            }
        } catch {
            delegate?.didFail(with: error)
        }
    }
    
    // MARK: - Helpers
    private func performGetRequest(with urlString: String, onCompletionCallback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: onCompletionCallback)
            task.resume()
        }
    }
    
    private func performPostRequest(with urlString: String, body: Data, onCompletionCallback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = body
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: onCompletionCallback)
            task.resume()
        }
    }
    
    private func performPutRequest(with urlString: String, body: Data ,onCompletionCallback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "PUT"
            request.httpBody = body
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request, completionHandler: onCompletionCallback)
            task.resume()
        }
    }
}
