//
//  GameGraphView.swift
//  MJS
//
//  Created by Robert Goedman on 5/8/24.
//

import SwiftUI
import SwiftData
import Charts

struct GameGraphView {
  @State var tournament: Tournament
}

extension GameGraphView: View {

  var body: some View {
    let scores = [  (player: tournament.fpName, data: tournament.sortedFpScores.filter { $0.name == tournament.fpName}),
                    (player: tournament.spName, data: tournament.sortedSpScores.filter { $0.name == tournament.spName}),
                    (player: tournament.tpName, data: tournament.sortedTpScores.filter { $0.name == tournament.tpName}),
                    (player: tournament.lpName, data: tournament.sortedLpScores.filter { $0.name == tournament.lpName}) ]

    Chart {
      ForEach(scores, id: \.player) { players in
        ForEach(players.data) { scores in
          LineMark(
            x: .value("Game", scores.game),
            y: .value("Score", scores.score)
          )
          .foregroundStyle(by: .value("Player", players.player))
        }
      }
    }
    .frame(height: 200)
  }
}
