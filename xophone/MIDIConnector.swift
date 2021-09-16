//
//  MIDIConnector.swift
//  monoleap
//
//  Created by Omer Elimelech on 10/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import CoreMIDI

class MIDIConnector: NSObject, MidiConnectorImpl {

    @objc static let sharedInstance = MIDIConnector()
    var outputPort: MIDIPortRef = MIDIPortRef()
    var client: MIDIClientRef = MIDIClientRef()
    
    override init() {
        super.init()
        MIDIClientCreate("Monoleap" as CFString, nil, nil, &client);
        MIDIOutputPortCreate(client, "MonoLeap Output Port" as CFString, &outputPort);
    }
    
    func sendNote(on noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        let message: [UInt8] = [0x90, UInt8(channel), UInt8(velocity)]
        self.sendMidi(message)
    }
    
    public func sendNoteOff(_ noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        let message: [UInt8] = [0x80, UInt8(noteNumber), 0]
        self.sendMidi(message)
    }
    
    public func sendControllerChange(_ ccNumber: Int, value: Int, inChannel channel: Int) {
        let message: [UInt8] = [176, UInt8(ccNumber), UInt8(value)]
        self.sendMidi(message)
    }

    func sendMidi(_ message: UnsafePointer<Byte>) {
        var packetList: MIDIPacketList = MIDIPacketList()
        let packet = MIDIPacketListInit(&packetList)
        MIDIPacketListAdd(&packetList, MemoryLayout.size(ofValue: packetList), packet, 0, MemoryLayout.size(ofValue: message), message)
        let destinationCount = MIDIGetNumberOfDestinations()
        for i in 0...destinationCount - 1 {
            MIDISend(outputPort, MIDIGetDestination(i), &packetList)
        }
    }
}
