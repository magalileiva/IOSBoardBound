//
//  User.swift
//  BoardBound
//
//  Created by Magali Leiva on 12/6/24.
//

import Foundation

struct User: Codable,Identifiable {
    let id: Int
    let username: String
    let email: String
}

struct InfoPlayer: Codable {
    let createdMatches, playedMatches: [Match]
}
	
