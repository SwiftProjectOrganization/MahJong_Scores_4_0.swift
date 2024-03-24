//
//  Item.swift
//  MJS
//
//  Created by Robert Goedman on 3/24/24.
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
