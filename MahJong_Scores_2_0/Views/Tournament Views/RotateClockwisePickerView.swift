//
//  RotateClockwisePickerView.swift
//  MahJong_Scores_2_0
//
//  Created by Robert Goedman on 5/27/24.
//

import SwiftUI

let rotateClocwiseTypes = RotateClockwiseType.allCases

struct RotateClockwisePickerView {
  @Binding var selectedRotation: RotateClockwiseType
}

extension RotateClockwisePickerView: View {
  var body: some View {
    Picker("Rule set",
           selection: $selectedRotation) {
      ForEach(rotateClocwiseTypes) { rotateClockwiseType in
        Text(rotateClockwiseType.description)
          .tint(selectedRotation == rotateClockwiseType ? .blue : .gray)
       }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal)
    .onChange(of: selectedRotation) { oldValue, newValue in
      selectedRotation = newValue
      print(newValue)
    }
  }
}

#Preview {
  RotateClockwisePickerView(selectedRotation: .constant(RotateClockwiseType.clockwise))
}
