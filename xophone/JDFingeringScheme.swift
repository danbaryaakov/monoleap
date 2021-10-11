//
//  JDFingeringScheme.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 11/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

struct JDFingeringScheme : FingeringScheme {
    
    let name = "Diercks"
    
    struct NoteKey : Hashable {
        var leading: Int
        var following: Int
        
        static func == (lhs: NoteKey, rhs: NoteKey) -> Bool {
            lhs.leading == rhs.leading && lhs.following == rhs.following
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(leading)
            hasher.combine(following)
        }
        
    }
    
    var notes: [NoteKey: Int] = [
        
        NoteKey(leading: 8, following: 8) : 0,      // C
        NoteKey(leading: 5, following: 8) : 1,      // C#
        NoteKey(leading: 3, following: 8) : 2,      // D
        NoteKey(leading: 7, following: 8) : 3,      // D#
        NoteKey(leading: 2, following: 8) : 4,      // E
        NoteKey(leading: 1, following: 8) : 5,      // F
        NoteKey(leading: 6, following: 8) : 6,      // F#
        
        NoteKey(leading: 8, following: 7) : 6,      // F#
        NoteKey(leading: 3, following: 7) : 7,      // G
        NoteKey(leading: 7, following: 7) : 8,      // G#
        NoteKey(leading: 2, following: 7) : 9,      // A
        NoteKey(leading: 4, following: 7) : 10,     // A#
        NoteKey(leading: 1, following: 7) : 11,     // B
        NoteKey(leading: 6, following: 7) : 12,     // C
        
        NoteKey(leading: 8, following: 3) : 12,     // C
        NoteKey(leading: 5, following: 3) : 13,     // C#
        NoteKey(leading: 3, following: 3) : 14,     // D
        NoteKey(leading: 7, following: 3) : 15,     // D#
        NoteKey(leading: 2, following: 3) : 16,     // E
        NoteKey(leading: 1, following: 3) : 17,     // F
        NoteKey(leading: 6, following: 3) : 18,     // F#
        
        NoteKey(leading: 8, following: 4) : 18,     // F#
        NoteKey(leading: 3, following: 4) : 19,     // G
        NoteKey(leading: 7, following: 4) : 20,     // G#
        NoteKey(leading: 2, following: 4) : 21,     // A
        NoteKey(leading: 4, following: 4) : 22,     // A#
        NoteKey(leading: 1, following: 4) : 23,     // B
        NoteKey(leading: 6, following: 4) : 24,     // C
        
        NoteKey(leading: 8, following: 2) : 24,     // C
        NoteKey(leading: 5, following: 2) : 25,     // C#
        NoteKey(leading: 3, following: 2) : 26,     // D
        NoteKey(leading: 7, following: 2) : 27,     // D#
        NoteKey(leading: 2, following: 2) : 28,     // E
        NoteKey(leading: 1, following: 2) : 29,     // F
        NoteKey(leading: 6, following: 2) : 30,     // F#
        
        NoteKey(leading: 8, following: 1) : 30,     // F#
        NoteKey(leading: 3, following: 1) : 31,     // G
        NoteKey(leading: 7, following: 1) : 32,     // G#
        NoteKey(leading: 2, following: 1) : 33,     // A
        NoteKey(leading: 4, following: 1) : 34,     // A#
        NoteKey(leading: 1, following: 1) : 35,     // B
        NoteKey(leading: 6, following: 1) : 36,     // C
        
        NoteKey(leading: 8, following: 6) : 36,     // C
        NoteKey(leading: 5, following: 6) : 37,     // C#
        NoteKey(leading: 3, following: 6) : 38,     // D
        NoteKey(leading: 7, following: 6) : 39,     // D#
        NoteKey(leading: 2, following: 6) : 40,     // E
        NoteKey(leading: 1, following: 6) : 41,     // F
        NoteKey(leading: 6, following: 6) : 42,     // F#
        
        NoteKey(leading: 8, following: 5) : 42,     // F#
        NoteKey(leading: 3, following: 5) : 43,     // G
        NoteKey(leading: 7, following: 5) : 44,     // G#
        NoteKey(leading: 2, following: 5) : 45,     // A
        NoteKey(leading: 4, following: 5) : 46,     // A#
        NoteKey(leading: 1, following: 5) : 47,     // B
        NoteKey(leading: 6, following: 5) : 48,     // C
    ]
    
    func getNoteNumber(leadingPattern: Int, followingPattern: Int) -> Int? {
        let rootNote = 48
        let key = NoteKey(leading: leadingPattern, following: followingPattern)
        if let note = notes[key] {
            return rootNote + note
        }
        return nil
    }
}
