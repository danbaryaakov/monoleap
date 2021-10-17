//
//  JDFingeringScheme.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 11/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

struct JDV2FingeringScheme : FingeringScheme {
    
    let name = "Diercks Alt"
    
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
        NoteKey(leading: 4, following: 8) : 3,      // D#
        NoteKey(leading: 2, following: 8) : 4,      // E
        NoteKey(leading: 1, following: 8) : 5,      // F
        NoteKey(leading: 6, following: 8) : 6,      // F#
        
        NoteKey(leading: 8, following: 5) : 6,      // F#
        NoteKey(leading: 3, following: 5) : 7,      // G
        NoteKey(leading: 5, following: 5) : 8,      // G#
        NoteKey(leading: 2, following: 5) : 9,      // A
        NoteKey(leading: 4, following: 5) : 10,     // A#
        NoteKey(leading: 1, following: 5) : 11,     // B
        NoteKey(leading: 6, following: 5) : 12,     // C
        
        NoteKey(leading: 8, following: 4) : 12,     // C
        NoteKey(leading: 5, following: 4) : 13,     // C#
        NoteKey(leading: 3, following: 4) : 14,     // D
        NoteKey(leading: 4, following: 4) : 15,     // D#
        NoteKey(leading: 2, following: 4) : 16,     // E
        NoteKey(leading: 1, following: 4) : 17,     // F
        NoteKey(leading: 6, following: 4) : 18,     // F#
        
        NoteKey(leading: 8, following: 3) : 18,     // F#
        NoteKey(leading: 3, following: 3) : 19,     // G
        NoteKey(leading: 5, following: 3) : 20,     // G#
        NoteKey(leading: 2, following: 3) : 21,     // A
        NoteKey(leading: 4, following: 3) : 22,     // A#
        NoteKey(leading: 1, following: 3) : 23,     // B
        NoteKey(leading: 6, following: 3) : 24,     // C
        
        NoteKey(leading: 8, following: 2) : 24,     // C
        NoteKey(leading: 5, following: 2) : 25,     // C#
        NoteKey(leading: 3, following: 2) : 26,     // D
        NoteKey(leading: 4, following: 2) : 27,     // D#
        NoteKey(leading: 2, following: 2) : 28,     // E
        NoteKey(leading: 1, following: 2) : 29,     // F
        NoteKey(leading: 6, following: 2) : 30,     // F#
        
        NoteKey(leading: 8, following: 1) : 30,     // F#
        NoteKey(leading: 3, following: 1) : 31,     // G
        NoteKey(leading: 5, following: 1) : 32,     // G#
        NoteKey(leading: 2, following: 1) : 33,     // A
        NoteKey(leading: 4, following: 1) : 34,     // A#
        NoteKey(leading: 1, following: 1) : 35,     // B
        NoteKey(leading: 6, following: 1) : 36,     // C
        
        NoteKey(leading: 8, following: 6) : 36,     // C
        NoteKey(leading: 5, following: 6) : 37,     // C#
        NoteKey(leading: 3, following: 6) : 38,     // D
        NoteKey(leading: 4, following: 6) : 39,     // D#
        NoteKey(leading: 2, following: 6) : 40,     // E
        NoteKey(leading: 1, following: 6) : 41,     // F
        NoteKey(leading: 6, following: 6) : 42,     // F#
        
        NoteKey(leading: 8, following: 7) : 42,     // F#
        NoteKey(leading: 3, following: 7) : 43,     // G
        NoteKey(leading: 5, following: 7) : 44,     // G#
        NoteKey(leading: 2, following: 7) : 45,     // A
        NoteKey(leading: 4, following: 7) : 46,     // A#
        NoteKey(leading: 1, following: 7) : 47,     // B
        NoteKey(leading: 6, following: 7) : 48,     // C
    ]
    
    func getNoteNumber(leadingPattern: Int, followingPattern: Int) -> Int? {
        let key = NoteKey(leading: leadingPattern, following: followingPattern)
        return notes[key]
    }
}
