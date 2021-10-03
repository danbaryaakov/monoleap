//
//  ScaleSelector.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct ScaleSelector: View {
    @State var selection: Set<Int> = Set<Int>(Settings.scale.value)
    var onScaleChanged: (() -> Void)?
    var options = Scale.scales.map { DropdownOption(key: $0.name, value: $0.name) }
    var noteOptions = [
        DropdownOption(key: "0", value: "C"),
        DropdownOption(key: "1", value: "C#"),
        DropdownOption(key: "2", value: "D"),
        DropdownOption(key: "3", value: "D#"),
        DropdownOption(key: "4", value: "E"),
        DropdownOption(key: "5", value: "F"),
        DropdownOption(key: "6", value: "F#"),
        DropdownOption(key: "7", value: "G"),
        DropdownOption(key: "8", value: "G#"),
        DropdownOption(key: "9", value: "A"),
        DropdownOption(key: "10", value: "A#"),
        DropdownOption(key: "11", value: "B")
    ]
    let whites = [0, 2, 4, 5, 7, 9, 11]
    let blacks = [1, 3, 6, 8, 10]
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                DropdownSelector(
                    selectedOption: options[0],
                    placeholder: "Apply Scale",
                    options: options,
                    onOptionSelected: { option in
                        selection = Scale.scales.filter { $0.name == option.key }.first?.notes ?? []
                        Settings.scale.value = Array(selection)
                        onScaleChanged?()
                    }).zIndex(2.0).frame(width: 200)
                Spacer()
                    DropdownSelector(
                        selectedOption: noteOptions[Settings.scaleRoot.value],
                        placeholder: "Scale Root",
                        options: noteOptions,
                        onOptionSelected: { option in
                            let index: Int = Int(option.key) ?? 0
                            Settings.scaleRoot.value = index
                        }).zIndex(2.0).frame(width: 100)
            }.zIndex(1.0)
            HStack {
                ForEach((0...11), id: \.self) { index in
                    VStack {
                        if whites.contains(index) {
                            Spacer(minLength: 20)
                        }
                        if selection.contains(index) {
                            RoundedRectangle(cornerRadius: 10).fill(MonoleapAssets.controlColor)
                        } else {
                            RoundedRectangle(cornerRadius: 10).strokeBorder(MonoleapAssets.controlColor).contentShape(Rectangle())
                        }
                        if (blacks.contains(index)) {
                            Spacer(minLength: 20)
                        }
                    }.onTapGesture {
                        if (selection.contains(index)) {
                            selection.remove(index)
                        } else {
                            selection.insert(index)
                        }
                        Settings.scale.value = Array(selection)
                        onScaleChanged?()
                    }
                }
            }.padding(20).overlay(RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(MonoleapAssets.controlColor)).frame(minHeight: 180, maxHeight: 220)
        }
    }
}
