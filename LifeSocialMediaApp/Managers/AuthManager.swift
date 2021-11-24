//
//  AuthManager.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 15.11.21..
//

import Foundation
import FirebaseAuth

final class AuthManager {
    
    static let shared = AuthManager()
    
    public var isSignedIn: Bool = false
    
    private init() { }
    
    /// Method to sign in the user
    public func signIn(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(true))
        }
    }
    
    /// Method called to create a new account and sign up the user
    public func signUp(email: String,
                       password: String,
                       user: UserInfo,
                       completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            DatabaseManager.shared.uploadUserInfo(user: user)
            completion(.success(true))
        }
        
    }
    
    /// Method called to sign out the user
    public func signOut(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
            return
        }
    }
    
}
