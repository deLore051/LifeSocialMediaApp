//
//  PostInfo.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 20.11.21..
//

import Foundation

struct PostInfo {
    let likes: Int
    let comments: [Comment]
}

struct Comment {
    let postedByUser: String
    let description: String
}
