//
//  Scores.swift
//  MJS
//
//  Created by Robert Goedman on 5/9/24.
//

import Foundation
import SwiftData
import Charts

@Model
public class Score {
  public var id = UUID()
  var name: String
  var game: Int
  var score: Int
  var tournament: Tournament?
  
  init(_ name: String,
       _ game: Int,
       _ score: Int) {
    self.name = name
    self.game = game
    self.score = score
  }
}
