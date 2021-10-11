//
//  JDFingeringScheme.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 11/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

struct JDFingeringScheme : FingeringScheme {
    
    let name = "JD"
    
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
        
        NoteKey(leading: 8, following: 4) : 18,      // F#
        NoteKey(leading: 3, following: 4) : 19,      // G
        NoteKey(leading: 7, following: 4) : 20,      // G#
        NoteKey(leading: 2, following: 4) : 21,      // A
        NoteKey(leading: 4, following: 4) : 22,     // A#
        NoteKey(leading: 1, following: 4) : 23,     // B
        NoteKey(leading: 6, following: 4) : 24,     // C
        
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
