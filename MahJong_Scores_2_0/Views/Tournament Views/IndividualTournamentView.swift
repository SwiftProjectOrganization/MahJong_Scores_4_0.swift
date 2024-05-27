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
            if tournament.fpName == tournament.windPlayer {
              Text(createPlayerLabel(tournament, 0))
                .font(.headline)
                .foregroundColor(.blue)
            } else {
              Text(createPlayerLabel(tournament, 0))
                .font(.headline)
            }
           Spacer()
          }
          HStack {
            if tournament.spName == tournament.windPlayer {
              Text(createPlayerLabel(tournament, 1))
                .font(.headline)
                .foregroundColor(.blue)
            } else {
              Text(createPlayerLabel(tournament, 1))
                .font(.headline)
            }
            Spacer()
            if tournament.lpName == tournament.windPlayer {
              Text(createPlayerLabel(tournament, 3))
                .font(.headline)
                .foregroundColor(.blue)
            } else {
              Text(createPlayerLabel(tournament, 3))
                .font(.headline)
            }
          }
          .font(.headline)

          HStack {
            Spacer()
            if tournament.tpName == tournament.windPlayer {
              Text(createPlayerLabel(tournament, 2))
                .font(.headline)
                .foregroundColor(.blue)
            } else {
              Text(createPlayerLabel(tournament, 2))
                .font(.headline)
            }
            Spacer()
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
    let player = [tournament.fpName!, tournament.spName!, tournament.tpName!, tournament.lpName!][index]
    let currentWind = tournament.playersToWindsInGame![player]
    let score = tournament.playerTournamentScore![player]
    let playerLabel = "\(currentWind!):" + "\(player)" + " (\(score!))"
    return playerLabel
  }
}
