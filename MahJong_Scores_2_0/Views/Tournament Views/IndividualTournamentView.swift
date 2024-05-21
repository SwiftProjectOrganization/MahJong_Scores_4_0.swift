//
//  IndividualTournamentView.swift
//  MJS
//
//  Created by Robert Goedman on 3/25/24.
//

import SwiftUI
import SwiftData


struct IndividualTournamentView {
  @State private var title = ""
  @State private var isAddingGame = false
  @State private var isCompleteGameViewDisplayed = false
  @State var tournament: Tournament
  @Environment(\.dismiss) private var dismiss
}

extension IndividualTournamentView: View {
  var body: some View {
    VStack {
      List {
        Section("Tournament") {
          VStack {
            Text(tournament.title)
          }
          VStack {
            GameGraphView(tournament: tournament)
          }
        }
        Section("Players") {
          HStack {
            Spacer()
            Text(createPlayerLabel(tournament, 0))
              .font(.headline)
            Spacer()
          }
          HStack {
            Text(createPlayerLabel(tournament, 3));
            Spacer();
            Text(createPlayerLabel(tournament, 1))
          }
          .font(.headline)

          HStack {
            Spacer();Text(createPlayerLabel(tournament, 2));Spacer()
          }
          .font(.headline)
        }
        HStack {
          Spacer()
          Button("Game completed") {
            isCompleteGameViewDisplayed = true
          }
          .disabled(tournament.scheduleItem > 15)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
          .multilineTextAlignment(.center)
        }
      }
      
      .sheet(isPresented: $isCompleteGameViewDisplayed) {
        CompleteGameView(tournament: $tournament,
                         isCompleteGameViewDisplayed: .constant(true))
      }
    }
    .onAppear {
      title = tournament.title
    }
    .onDisappear {
      title = tournament.title
    }
  }
}

extension IndividualTournamentView {
  private func createPlayerLabel(_ tournament: Tournament, _ index: Int) -> String {
    //let currentWind = tournament.winds![index]
    //let player = tournament.windsToPlayersInGame![currentWind]
    let player = [tournament.fpName!, tournament.spName!, tournament.tpName!, tournament.lpName!][index]
    let currentWind = tournament.playersToWindsInGame![player]
    let score = tournament.playerTournamentScore![player]
    let playerLabel = "\(currentWind!):" + "\(player)" + " (\(score!))"
    return playerLabel
  }
}
