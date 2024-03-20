//
//  BoardGame.swift
//  BoardBound
//
//  Created by Magali Leiva on 20/3/24.
//

import Foundation

struct BoardGame: Codable,Identifiable,Hashable {
    let id: Int
    let name: String
    let playerNumber, duration, suggestedAge: Int
    let urlImage, difficulty: String
    let publisher: BoardGamePublisher
}
