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
            .addDocument(data: [
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
}
