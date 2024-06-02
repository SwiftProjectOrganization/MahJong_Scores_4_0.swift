//
//  LastTilePickerView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/29/24.
//

import SwiftUI

struct LastTilePickerView: View {
  @State var players: [String]
  @State var selection: LastTileType = LastTileType.firstPlayer
  
  var body: some View {
    VStack {
        HStack {
            Picker("Source of last tile?", selection: $selection) {
              ForEach(LastTileType.allCases, id: \.self) { aValidSelection in
                Text(players[aValidSelection.rawValue])
                  .padding()
              }
            }
            .pickerStyle(.segmented)
            .padding()
        }
        //Text("Value: \(players[selection.rawValue])")
    }
  }
}

#Preview {
  LastTilePickerView(players: ["Liesbeth", "Rob", "Nancy", "CareL"],
                     selection: LastTileType.firstPlayer)
}
