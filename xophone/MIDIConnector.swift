//
//  MIDIConnector.swift
//  monoleap
//
//  Created by Omer Elimelech on 10/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import AudioKit

class MIDIConnector: NSObject, MidiConnectorImpl {

    @objc static let sharedInstance = MIDIConnector()
    var midi = AudioKit.MIDI()
    
    override init() {
        super.init()
        midi.openOutput()
    }
    
    func sendNote(on noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        midi.sendEvent(MIDIEvent(noteOn: MIDINoteNumber(noteNumber), velocity: MIDIVelocity(127), channel: MIDIChannel(1)))
    }
    
    public func sendNoteOff(_ noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        midi.sendEvent(MIDIEvent(noteOff: MIDINoteNumber(noteNumber), velocity: MIDIVelocity(127), channel: MIDIChannel(1)))
    }
    
    public func sendControllerChange(_ ccNumber: Int, value: Int, inChannel channel: Int) {
        midi.sendControllerMessage(MIDIByte(ccNumber), value: MIDIByte(value))
    }

}
