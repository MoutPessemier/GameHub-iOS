//
//  SessionManager.swift
//  GameHub-iOS
//
//  Created by Mout Pessemier on 12/12/2019.
//  Copyright © 2019 Digitized. All rights reserved.
//

import Foundation
import Auth0

class SessionManager {
    
    static let shared = SessionManager()
    private let authentication = Auth0.authentication()
    let credentialsManager: CredentialsManager!
    var profile: UserInfo?
    var credentials: Credentials?
    var metadata: ManagementObject?
    var user: User?
    
    private init () {
        self.credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        _ = self.authentication.logging(enabled: true)
    }
    
    func retrieveProfile(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.credentials?.accessToken
            else { return callback(CredentialsManagerError.noCredentials) }
        self.authentication
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
        }
    }
    
    func getMetaData(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.credentials?.accessToken
            else { return callback(CredentialsManagerError.noCredentials) }
        Auth0
            .users(token: accessToken)
            .get(profile!.sub, fields: ["user_metadata"])
            .start { (result) in
                switch result {
                case .success(let meta):
                    self.metadata = (meta["user_metadata"] as! ManagementObject)
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
        }
    }
    
    func store(credentials: Credentials) -> Bool {
        self.credentials = credentials
        // Store credentials in KeyChain
        return self.credentialsManager.store(credentials: credentials)
    }
    
    func logout(_ callback: @escaping (Error?) -> Void) {
        // Remove credentials from KeyChain
        self.credentials = nil
        self.profile = nil
        self.user = nil
        self.metadata = nil
        self.credentialsManager.revoke(callback)
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
