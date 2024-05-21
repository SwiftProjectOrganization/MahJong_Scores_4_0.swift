# MahJongS_Scores_2_0.swift

## Purpose

MahJong_Scores_2_0.swift is an IOS application to keep scores of one or more MahJong tournaments.
This project uses CloudKit to sync owner's devices.

A MahJong tournament consists of all four players being the wind players for all 4 winds. Thus in total at least 26 games, but usually more. 

Completion of a tournament can take days, weeks or even much longer. That's why I developed this little app.

## Usage

Create a tournament by tapping the "+". Select the newly created tournament. All players should have 2000 points. Press "Game completed" and, if necessary, rotate the players and enter the computed scores.

## Notes

The "computed scores" are the game results for each player.

## To do

1. Use of @AppStorage for rule set and wind positioning in Tournaments.swift

2. Is it useful to keep an overall average player score across tournaments?
