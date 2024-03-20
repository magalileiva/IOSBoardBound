//
//  Item.swift
//  BoardBound
//
//  Created by Magali Leiva on 20/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
