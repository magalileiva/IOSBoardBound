//
//  Comment.swift
//  BoardBound
//
//  Created by Magali Leiva on 19/6/24.
//

import Foundation

struct Comment: Codable,Identifiable {
    let id: Int?
    let text: String
    let user: User
}
