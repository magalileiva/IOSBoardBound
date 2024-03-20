//
//  Match.swift
//  BoardBound
//
//  Created by Magali Leiva on 19/6/24.
//

import Foundation

struct Match: Codable,Identifiable  {
    let id, minNumPlayer, maxNumPlayer: Int
    let date, hour, place, status: String
    let creatorPlayer: User
    let boardGame: BoardGame
    let players: [User]
    var comments: [Comment]
}
