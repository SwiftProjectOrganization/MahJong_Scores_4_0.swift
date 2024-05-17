//
//  CompleteGameView.swift
//  MJS
//
//  Created by Robert Goedman on 3/28/24.
//

import SwiftUI
import SwiftData

struct CompleteGameView {
  @State private var gameWinnerName: String = ""
  @State private var gameSpName: String = ""
  @State private var gameTpName: String = ""
  @State private var gameLpName: String = ""
  @State private var gameWinnerScore: String = ""
  @State private var gameSpScore: String = ""
  @State private var gameTpScore: String = ""
  @State private var gameLpScore: String = ""
  @Binding var tournament: Tournament
  @Environment(\.scenePhase) private var scenePhase
  @FocusState private var focusedField
  @Binding var isCompleteGameViewDisplayed: Bool
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context
}


extension CompleteGameView: View {
    var body: some View {
      VStack(spacing: 50) {
        Text("Enter game scores and press `save`.")
          .font(.largeTitle)
        VStack {
          List {
            HStack {
              Spacer(minLength: 40)
              Text("\(gameWinnerName)")
                .multilineTextAlignment(.leading)
              Spacer()
              TextField("Game score", text: $gameWinnerScore)
                .focused($focusedField)
                .multilineTextAlignment(.center)
             Spacer(minLength: 40)
            }
            HStack {
              Spacer(minLength: 40)
              Text("\(gameSpName)")
                .multilineTextAlignment(.leading)
              Spacer()
              TextField("Game score", text: $gameSpScore)
                .multilineTextAlignment(.center)
             Spacer(minLength: 40)
            }
            HStack {
              Spacer(minLength: 40)
              Text("\(gameTpName)")
                .multilineTextAlignment(.leading)
              Spacer()
              TextField("Game score:", text: $gameTpScore)
                .multilineTextAlignment(.center)
              Spacer(minLength: 40)
            }
            HStack {
              Spacer(minLength: 40)
              Text("\(gameLpName)")
                .multilineTextAlignment(.leading)
              Spacer()
              TextField("Game score:", text: $gameLpScore)
                .multilineTextAlignment(.center)
               Spacer(minLength: 40)
            }
          }
        }
        .keyboardType(.numberPad)
        HStack {
          Spacer()
          Button("Cancel",
                 role: .cancel) {
            isCompleteGameViewDisplayed = false
            dismiss()
          }
          .buttonStyle(.bordered)
          Button("Rotate") {
            rotate()
          }
          .buttonStyle(.bordered)
          Spacer()
          Button("Save") {
            isCompleteGameViewDisplayed = false
            //print("Save pressed")
            save(tournament)
          }
          .disabled(anyFieldEmpty())
          .buttonStyle(.borderedProminent)
          Spacer()
        }
        Spacer()
       }
      .onAppear {
        gameWinnerName = tournament.players![0]
        gameSpName = tournament.players![1]
        gameTpName = tournament.players![2]
        gameLpName = tournament.players![3]
        gameWinnerScore = ""
        gameSpScore = ""
        gameTpScore = ""
        gameLpScore = ""
        focusedField = true
      }
    }
}

extension CompleteGameView {
  func anyFieldEmpty() -> Bool {
    let namesEmpty = gameWinnerName.isEmpty || gameSpName.isEmpty || gameTpName.isEmpty || gameLpName.isEmpty
    let scoresEmpty = gameWinnerScore.isEmpty || gameSpScore.isEmpty || gameTpScore.isEmpty || gameLpScore.isEmpty
    return namesEmpty || scoresEmpty
  }
}

extension CompleteGameView {
  func rotate() {
    print("Rotate called")
    let tmpName = gameWinnerName
    gameWinnerName = gameSpName
    gameSpName = gameTpName
    gameTpName = gameLpName
    gameLpName = tmpName
  }
}

extension CompleteGameView {
  private func save(_ tournament: Tournament) {
    //print((gameWinnerName, gameSpName, gameTpName, gameLpName))
    //print((gameWinnerScore, gameSpScore, gameTpScore, gameLpScore))
    tournament.lastGame += 1
    tournament.gameWinnerName = gameWinnerName
    tournament.playerGameScore![gameWinnerName] = Int(gameWinnerScore)
    tournament.playerGameScore![gameSpName] = Int(gameSpScore)
    tournament.playerGameScore![gameTpName] = Int(gameTpScore)
    tournament.playerGameScore![gameLpName] = Int(gameLpScore)
    tournament.updateTournamentScore(tournament)
    //printTournament(tournament)
    focusedField = false
    dismiss()
  }
}



