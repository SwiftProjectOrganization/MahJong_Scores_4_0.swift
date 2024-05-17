//
//  AddTournamentView.swift
//  MJS
//
//  Created by Robert Goedman on 3/25/24.
//

import SwiftUI
import SwiftData

struct AddTournamentView {
  @State private var fp: String = ""
  @State private var sp: String = ""
  @State private var tp: String = ""
  @State private var lp: String = ""
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusedField
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
}

extension AddTournamentView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("Enter all 4 players and press `save`.")
        .font(.largeTitle)
      Spacer()
      HStack {
        TextField("East wind player", text: $fp)
          .focused($focusedField)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      HStack {
        TextField("South wind player", text: $sp)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      HStack {
        TextField("West wind player:", text: $tp)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      HStack {
        TextField("North wind player", text: $lp)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
      }
      Spacer()
      HStack {
        Spacer()
        Button("Cancel",
               role: .cancel) {
          dismiss()
        }
        Spacer()
        Button("Save",
               action: save)
        .disabled(fp.isEmpty || sp.isEmpty || tp.isEmpty || lp.isEmpty)
        Spacer()
      }
      .font(.largeTitle)
      Spacer()
    }
    .onAppear {
      focusedField = true
    }
  }
}

extension AddTournamentView {
  private func save() {
    focusedField = false
    let tournament = Tournament()
    tournament.scheduleItem = 0
    tournament.fpName = fp
    tournament.spName = sp
    tournament.tpName = tp
    tournament.lpName = lp
    tournament.players = [fp, sp, tp, lp]
    tournament.winds = ["East", "South", "West", "North"]
    let scores = [2000, 2000, 2000, 2000]
    tournament.playerTournamentScore = Dictionary(uniqueKeysWithValues: zip(tournament.players!, scores))
    tournament.playerGameScore = Dictionary(uniqueKeysWithValues: zip(tournament.players!, [0,0,0,0]))
    let tmp = tournament.windsAndPlayers(tournament.winds!, tournament.players!, 0)
    tournament.windsToPlayersInGame = Dictionary(uniqueKeysWithValues: zip(tmp.0, tmp.1))
    tournament.playersToWindsInGame = Dictionary(uniqueKeysWithValues: zip(tmp.1, tmp.0))
    tournament.currentWind = tmp.0[0]
    tournament.windPlayer = tmp.1[0]
    tournament.lastGame += 1
    tournament.fpScores.append(Score(fp, tournament.lastGame, 2000))
    tournament.spScores.append(Score(sp, tournament.lastGame, 2000))
    tournament.tpScores.append(Score(tp, tournament.lastGame, 2000))
    tournament.lpScores.append(Score(lp, tournament.lastGame, 2000))
    context.insert(tournament)
    printTournament(tournament)
    dismiss()
  }
}

#Preview {
    AddTournamentView()
}
