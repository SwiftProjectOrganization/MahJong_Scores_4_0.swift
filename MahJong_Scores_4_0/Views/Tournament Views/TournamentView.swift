//
//  TournamentView.swift
//  MJS
//
//  Created by Robert Goedman on 3/25/24.
//

import SwiftUI
import SwiftData

@MainActor
struct TournamentView {
  @State private var isAddingTournament = false
  @Environment(\.modelContext) private var context
  @Query var tournaments: [Tournament]
}

extension TournamentView: View {
  var body: some View {
    NavigationStack {
      List {
        ForEach(tournaments) { tournament in
          NavigationLink(tournament.title,
                         value: tournament)
        }
        .onDelete { indexSet in
          if let index = indexSet.first {
            context.delete(tournaments[index])
          }
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isAddingTournament = true
          } label: {
            Label("Add Tournament", systemImage: "plus")
          }
        }
      }
      .navigationTitle("Tournaments")
      .navigationDestination(for: Tournament.self) { tournament in
        IndividualTournamentView(tournament: tournament)
      }
      Spacer()

    }
    .sheet(isPresented: $isAddingTournament) {
        AddTournamentView()
    }
  }
}

#Preview {
  TournamentView()
    .modelContainer(previewContainer)
}
