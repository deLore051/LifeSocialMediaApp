//
//  DatabaseManager.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 20.11.21..
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Firestore.firestore()
    
    private init() { }
    
    /// Upload users information to firestore database
    public func uploadUserInfo(user: UserInfo) {
        self.database
            .collection(K.FStore.User.userInfoCollectionName)
            .document("\(user.email)")
            .setData([
                K.FStore.User.email: user.email,
                K.FStore.User.firstName: user.firstName,
                K.FStore.User.lastName: user.lastName,
                K.FStore.User.username: user.username,
                K.FStore.User.country: user.country,
                K.FStore.User.profilePhotoURL: ""
            ])
    }
    
    /// Upload post information to firestore database ( likes, comments )
    public func uploadPostInfo(post: PostInfo, image: UIImage, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    public func getUserInfo(for email: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        self.database
            .collection(K.FStore.User.userInfoCollectionName)
            .document("\(email)")
            .getDocument { documentSnapshot, error in
                guard let documentSnapshot = documentSnapshot,
                      let data = documentSnapshot.data(),
                      error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard let email = data[K.FStore.User.email] as? String,
                      let firstName = data[K.FStore.User.firstName] as? String,
                      let lastName = data[K.FStore.User.lastName] as? String,
                      let username = data[K.FStore.User.username] as? String,
                      let country = data[K.FStore.User.country] as? String,
                      let profilePhotoUrl = data[K.FStore.User.profilePhotoURL] as? String else { return }
                
                let user = UserInfo(
                    email: email,
                    username: username,
                    firstName: firstName,
                    lastName: lastName,
                    country: country,
                    profilePhotoURL: profilePhotoUrl)
                
                completion(.success(user))
            }
    }
}
