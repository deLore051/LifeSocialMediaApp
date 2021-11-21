//
//  StorageManager.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 20.11.21..
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage()
    
    /// Upload users profile photo to firestore storage
    public func uploadProfilePhoto(email: String, image: UIImage, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let jpegData = image.jpegData(compressionQuality: 0.2) else { return }
        storage
            .reference(withPath: "\(K.FStorage.profilePhotos)/\(email)/\(email)_profile.jpeg")
            .putData(jpegData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    print(error!.localizedDescription)
                    completion(.failure(error!))
                    return
                }
                completion(.success(true))
            }
    }
    
    /// Download url of our users profile photo
    public func downloadProfilePhotoURL(email:String, completion: @escaping (Result<URL, Error>) -> Void) {
        storage
            .reference(withPath: "\(K.FStorage.profilePhotos)/\(email)/\(email)_profile.jpeg")
            .downloadURL { url, error in
                guard let url = url, error == nil else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
    }
    
}
