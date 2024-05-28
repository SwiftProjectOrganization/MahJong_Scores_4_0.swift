//
//  TournamentTitleView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/27/24.
//

import SwiftUI

struct TournamentTitleView {
  @State var tournament: Tournament
}

extension TournamentTitleView: View {
  var body: some View {
    VStack {
      HStack {
        Text(tournament.currentWind!)
          .font(.headline)
          .foregroundColor(.blue)
        Spacer()
        Text(tournament.startDate!)
        Spacer()
      }
      Spacer()
      HStack {
        if tournament.fpName == tournament.windPlayer {
          Text(tournament.fpName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.fpName!)
            .font(.headline)
        }
        Spacer()
        if tournament.spName == tournament.windPlayer {
          Text(tournament.spName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.spName!)
            .font(.headline)
        }
        Spacer()
        if tournament.tpName == tournament.windPlayer {
          Text(tournament.tpName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.tpName!)
            .font(.headline)
        }
        Spacer()
        if tournament.lpName == tournament.windPlayer {
          Text(tournament.lpName!)
            .font(.headline)
            .foregroundColor(.blue)
        } else {
          Text(tournament.lpName!)
            .font(.headline)
        }
      }
    }
  }
}

//#Preview {
//    TournamentTitleView()
//}
