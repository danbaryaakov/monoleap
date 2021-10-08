//
//  MIDIConnector.swift
//  monoleap
//
//  Created by Omer Elimelech on 10/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import AudioKit

class MIDIConnector {
    
    static let instance = MIDIConnector()
    var midi = AudioKit.MIDI()
    
    init() {
        midi.openOutput()
    }
    
    func sendNote(on noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        midi.openOutput()
        midi.sendEvent(MIDIEvent(noteOn: MIDINoteNumber(noteNumber), velocity: MIDIVelocity(127), channel: MIDIChannel(channel)))
    }
    
    public func sendNoteOff(_ noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        midi.openOutput()
        midi.sendEvent(MIDIEvent(noteOff: MIDINoteNumber(noteNumber), velocity: MIDIVelocity(127), channel: MIDIChannel(channel)))
    }
    
    public func sendControllerChange(_ ccNumber: Int, value: Int, inChannel channel: Int) {
        midi.openOutput()
        midi.sendEvent(MIDIEvent(controllerChange: MIDIByte(ccNumber), value: MIDIByte(value), channel: MIDIChannel(channel)))
    }

}
