//
//  Scale.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//
import Foundation
import SwiftUI

public class ScaleMatcher : NSObject {
    
    static public func doesNoteMatchCurrentScale(_ noteNumber: Int) -> Bool {
        let rootNote = Settings.scaleRoot.value
        let scale = Settings.scale.value
        let noteIndex = noteNumber % 12
        let distance = noteIndex - rootNote
        if distance >= 0 {
            return scale.contains(distance)
        } else {
            return scale.contains(12 + distance)
        }
    }
    
}

struct Scale {
    
    let name: String
    let notes: Set<Int>
    
    init(name: String, notes: Set<Int>) {
        self.name = name
        self.notes = notes
    }
    
    static let scales = [
        Scale(name: "Chromatic", notes: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]),
        Scale(name: "Ionian", notes: [0, 2, 4, 5, 7, 9, 11]),
        Scale(name: "Dorian", notes: [0, 2, 3, 5, 7, 9, 10]),
        Scale(name: "Phrygian", notes: [0, 1, 3, 5, 7, 8, 10]),
        Scale(name: "Lydian", notes: [0, 2, 4, 6, 7, 9, 11]),
        Scale(name: "Mixolydian", notes: [0, 2, 4, 5, 7, 9, 10]),
        Scale(name: "Aeolian", notes: [0, 2, 3, 5, 7, 8, 10]),
        Scale(name: "Locrian", notes: [0, 1, 3, 5, 6, 8, 10]),
        Scale(name: "Major Pentatonic", notes: [0, 2, 4, 7, 9]),
        Scale(name: "Minor Pentatonic", notes: [0, 3, 5, 7, 10]),
        Scale(name: "Whole Tone", notes: [0, 2, 4, 6, 8, 10]),
        Scale(name: "Spanish", notes: [0, 1, 4, 5, 7, 8, 10]),
        Scale(name: "Gypsy", notes: [0, 2, 3, 6, 7, 8, 11]),
        Scale(name: "Arabian", notes: [0, 2, 4, 5, 6, 8, 10])
    ]
    
}
