//
//  PreviewData.swift
//  MJS
//
//  Created by Robert Goedman on 4/8/24.
//

import Foundation
import SwiftData

fileprivate var tournaments: [Tournament] = []
fileprivate var fpScores: [Score] = []
fileprivate var spScores: [Score] = []
fileprivate var tpScores: [Score] = []
fileprivate var lpScores: [Score] = []

let previewContainer: ModelContainer = {
  let schema = Schema([Tournament.self])
  let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
  do {
    let container = try ModelContainer(for: schema,
                                     configurations: configuration)
    try addTournaments(to: container, tournaments: tournaments)
    return container
  } catch {
    fatalError("Couldn't create container: \(error.localizedDescription)")
  }
}()

let previewTournament: Tournament = {
  let context = ModelContext(previewContainer)
  if let previewTournament = try? context.fetch(FetchDescriptor<Tournament>()).first {
    return previewTournament
  } else {
    fatalError("No Tournament in container")
  }
}()

fileprivate func addTournaments(to container: ModelContainer, tournaments: [Tournament]) throws {
  let context = ModelContext(container)
  
  var tournament: Tournament
  tournament = tournamentsSetup("Liesbeth", "Rob", "Nancy", "Carel")
  context.insert(tournament)
  tournament = tournamentsSetup("Fleur", "Cleo", "Lee", "Mick")
  context.insert(tournament)
  tournament = tournamentsSetup("Fem", "Juul", "Luuk", "Timme")
  context.insert(tournament)
  try context.save()
}

fileprivate func tournamentsSetup(_ fp: String, _ sp: String, _ tp: String, _ lp: String) -> Tournament {
  let tournament = Tournament(fp, sp, tp, lp, fp, "East", fp)
  tournament.scheduleItem = 0
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
  tournament.lastGame! += 1
  tournament.ruleSet = RuleSetType.traditional.description
  tournament.rotateClockwise = false
  tournament.fpScores!.append(Score(fp, tournament.lastGame!, 2000))
  tournament.spScores!.append(Score(sp, tournament.lastGame!, 2000))
  tournament.tpScores!.append(Score(tp, tournament.lastGame!, 2000))
  tournament.lpScores!.append(Score(lp, tournament.lastGame!, 2000))
  tournaments.append(tournament)
  print(tournaments.count)
  print(tournament.fpName!)
  return tournament
}

