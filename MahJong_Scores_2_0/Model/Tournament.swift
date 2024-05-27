//
//  Tournament.swift
//  MJ Scores
//
//  Created by Robert Goedman on 3/24/24.
//
//

import Foundation
import SwiftData

@Model
public class Tournament {

  // Tournament wide settings, currently not used
  
  var rotateClockwise: Bool?
  var ruleSet: String?
  let startDate: String?
  
  // Tournament wide values
  var scheduleItem: Int = 0
  var lastGame: Int?
  
  // Player names and sequence when tournament is started
  var fpName: String?
  var spName: String?
  var tpName: String?
  var lpName: String?
  
  // Game values
  var windPlayer: String?
  var currentWind: String?
  var players: [String]?
  var winds: [String]?
  var gameWinnerName: String?

  var playerTournamentScore: [String: Int]?
  var playerGameScore: [String: Int]?
  var windsToPlayersInGame: [String: String]?
  var playersToWindsInGame: [String: String]?

  @Relationship(deleteRule: .cascade,
                inverse: \Score.tournament)
  var fpScores: [Score]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \Score.tournament)
  var spScores: [Score]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \Score.tournament)
  var tpScores: [Score]?
  
  @Relationship(deleteRule: .cascade,
                inverse: \Score.tournament)
  var lpScores: [Score]?
  
  init(_ fpName: String,
       _ spName: String,
       _ tpName: String,
       _ lpName: String,
       _ windPlayer: String,
       _ currentWind: String,
       _ gameWinnerName: String) {
    self.rotateClockwise = true
    self.ruleSet = "INTERNATIONAL"
    self.startDate = dateToString()
    self.lastGame = -1
    self.fpName = fpName
    self.spName = spName
    self.tpName = tpName
    self.lpName = lpName
    self.windPlayer = windPlayer
    self.currentWind = currentWind
    self.gameWinnerName = gameWinnerName
    self.fpScores = []
    self.spScores = []
    self.tpScores = []
    self.lpScores = []
  }
}

extension Tournament {
    var title: String {
      "\(currentWind!) - \(startDate!): \n\(fpName!) \(spName!) \(tpName!) \(lpName!)"
    }
}

extension Tournament {
  var sortedFpScores: [Score] {
    let scores = self.fpScores!.filter { $0.tournament! == self }
    let sortedScores = scores.sorted {$0.game! < $1.game!}
    return sortedScores
  }
}

extension Tournament {
  var sortedSpScores: [Score] {
    let scores = self.spScores!.filter { $0.tournament! == self }
    let sortedScores = scores.sorted {$0.game! < $1.game!}
    return sortedScores
  }
}

extension Tournament {
  var sortedTpScores: [Score] {
    let scores = self.tpScores!.filter { $0.tournament! == self }
    let sortedScores = scores.sorted {$0.game! < $1.game!}
    return sortedScores
  }
}

extension Tournament {
  var sortedLpScores: [Score] {
    let scores = self.lpScores!.filter { $0.tournament! == self }
    let sortedScores = scores.sorted {$0.game! < $1.game!}
    return sortedScores
  }
}

extension Tournament {
  func rotateStringArray(_ stringArray: Array<String>, _ steps: Int = 1) -> Array<String> {
    var p = stringArray
    for _ in 1...steps {
      let tmp = p[0]
      p[0] = p[1]
      p[1] = p[2]
      p[2] = p[3]
      p[3] = tmp
    }
    return p
  }
}

extension Tournament {
  func windsAndPlayers(_ winds: Array<String>, _ players: Array<String>, _ item:Int) -> (Array<String>, Array<String>) {
    var w = winds
    var p = players
    if item > 0 {
      if item % 4 == 0 {
        p = rotateStringArray(p, 2)
        w = rotateStringArray(w, 1)
      } else {
        p = rotateStringArray(p, 1)
      }
    }
    return (w, p)
  }
}

extension Tournament {
  func updateTournamentScore(_ tournament: Tournament) {
    if tournament.gameWinnerName == tournament.windPlayer {
      for i in 0...3 {
        // Settle between winner and other players if game winner is wind player
        let pi = tournament.players![i]
        if pi == tournament.gameWinnerName {
          tournament.playerTournamentScore![pi]! += 6 * tournament.playerGameScore![tournament.gameWinnerName!]!
        } else {
          tournament.playerTournamentScore![pi]! -= 2 * tournament.playerGameScore![tournament.gameWinnerName!]!
          for j in 0...3 {
            let pj = tournament.players![j]
            if pi != pj && pj != tournament.gameWinnerName {
              // Settle between non-winners
              tournament.playerTournamentScore![pi]! += tournament.playerGameScore![pi]! - tournament.playerGameScore![pj]!
            }
          }
        }
      }
    } else {
      // Game winner is not the wind player
      for i in 0...3 {
        let pi = tournament.players![i]
        if pi == tournament.gameWinnerName {
          tournament.playerTournamentScore![pi]! += 4 * tournament.playerGameScore![tournament.gameWinnerName!]!
        } else {
          if pi == tournament.windPlayer {
            tournament.playerTournamentScore![pi]! -= 2 * tournament.playerGameScore![tournament.gameWinnerName!]!
          } else {
            tournament.playerTournamentScore![pi]! -= 1 * tournament.playerGameScore![tournament.gameWinnerName!]!
          }
          for j in 0...3 {
            let pj = tournament.players![j]
            if pi != pj {
              if pi != tournament.gameWinnerName && pj != tournament.gameWinnerName {
                // Settle between non-winners
                let dif = tournament.playerGameScore![pi]! - tournament.playerGameScore![pj]!
                if pi == tournament.windPlayer || pj == tournament.windPlayer {
                  tournament.playerTournamentScore![pi]! += 2 * dif
                } else {
                  tournament.playerTournamentScore![pi]! += 1 * dif
                }
              }
            }
          }
        }
      }
      tournament.scheduleItem += 1
      if tournament.scheduleItem < 16 {
        //
        // Generate the state of the tournament based on scheduleItem
        //
        // If scheduleItem == 0
        // tmp = (["East", "South", "West", "North"], ["Liesbeth", "Rob", "Nancy", "Carel"])
        // If scheduleItem == 1
        // tmp = [["East", "South", "West", "North"], [["Rob", "Nancy", "Carel", "Liesbeth"]]
        // ...
        // If scheduleItem == 4:
        // tmp = (["South", "West", "North", "East"], ["Rob", "Nancy", "Carel", "Liesbeth"])
        // ...
        //
        // (7, (["South", "West", "North", "East"], ["Liesbeth", "Rob", "Nancy", "Carel"]))
        // (8, (["West", "North", "East", "South"], ["Nancy", "Carel", "Liesbeth", "Rob"]))
        // (9, (["West", "North", "East", "South"], ["Carel", "Liesbeth", "Rob", "Nancy"]))
        //
        // Until scheduleItem == 16, at which point the tournament is "Done".
        //
        let tmp = tournament.windsAndPlayers(tournament.winds!, tournament.players!, tournament.scheduleItem)
        print((tournament.scheduleItem, tmp))
        tournament.windsToPlayersInGame = Dictionary(uniqueKeysWithValues: zip(tmp.0, tmp.1))
        tournament.playersToWindsInGame = Dictionary(uniqueKeysWithValues: zip(tmp.1, tmp.0))
        tournament.currentWind = tmp.0[0]
        tournament.windPlayer = tmp.1[0]
        tournament.winds = tmp.0
        tournament.players = tmp.1
      } else {
        tournament.currentWind = "Done"
      }
    }
    tournament.fpScores!.append(Score(tournament.fpName!, tournament.lastGame!, tournament.playerTournamentScore![tournament.fpName!]!))
    tournament.spScores!.append(Score(tournament.spName!, tournament.lastGame!, tournament.playerTournamentScore![tournament.spName!]!))
    tournament.tpScores!.append(Score(tournament.tpName!, tournament.lastGame!, tournament.playerTournamentScore![tournament.tpName!]!))
    tournament.lpScores!.append(Score(tournament.lpName!, tournament.lastGame!, tournament.playerTournamentScore![tournament.lpName!]!))
  }
}
