//
//  User.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import Foundation

class LocalUser: Codable {
    
    let userId: String?
    let email: String?
    let nickname: String?
    
    let profileImageUrl: String?
    let description: String?
    
    var articles: [String]? = [String]()
    
    init(userId: String,
         email: String,
         nickname: String,
         profileImageUrl: String?,
         description: String?,
         articles: [String]) {
        self.userId = userId
        self.email = email
        self.nickname = nickname
        self.profileImageUrl = profileImageUrl
        self.description = description
        self.articles = articles
    }
}
