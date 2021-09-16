//
//  MIDIConnector.swift
//  monoleap
//
//  Created by Omer Elimelech on 10/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import CoreMIDI

class MIDIConnector2: NSObject, MidiConnectorImpl {
    @objc static let shared = MIDIConnector2()
    var outputPort: MIDIPortRef = MIDIPortRef()
    var client: MIDIClientRef = MIDIClientRef()
    
    override init() {
        super.init()
        MIDIClientCreate("Monoleap" as CFString, nil, nil, &client);
        MIDIOutputPortCreate(client, "MonoLeap Output Port" as CFString, &outputPort);
    }
    public func sendNoteOn(noteNumber n: UInt8, inChannel channel: Int, withVelocity velocity: UInt8) {
        let message: [UInt8] = [UInt8(0x90), n, velocity]
        self.sendMidi(message: message)
    }
    
    public func sendNoteOff(noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int) {
        
    }
    
    public func sendControllerChange(ccNumber: Int, value: Int, inChannel channel: Int) {
        
    }
    
    func sendMidi(message: [UInt8]) {
//        guard let p = MIDIProtocolID(rawValue: 0) else { return }
//        if #available(iOS 14.0, *) {
//            var packetList: MIDIEventList = MIDIEventList()
//            let packet = MIDIEventListInit(&packetList, p)
//            MIDIEventListAdd(&packetList, Int(packetList.numPackets), packet, 0, message.count, message)
//            let destinationCount = MIDIGetNumberOfDestinations()
//            for i in 0...destinationCount - 1 {
//                MIDISendEventList(outputPort, MIDIGetDestination(i), &packetList)
//            }
//        } else { // fallback
//            var packetList: MIDIPacketList = MIDIPacketList()
//            let packet = MIDIPacketListInit(&packetList)
//            var outputArr = [UInt8]()
//            memcpy(&outputArr, message, message.count);
//            MIDIPacketListAdd(&packetList, Int(packetList.numPackets), packet, 0, message.count, outputArr)
//            let destinationCount = MIDIGetNumberOfDestinations()
//            for i in 0...destinationCount - 1 {
//                MIDISend(outputPort, MIDIGetDestination(i), &packetList)
//            }
//
//        }
        var packetList: MIDIPacketList = MIDIPacketList()
        let packet = MIDIPacketListInit(&packetList)
        var outputArr = [UInt8]()
        memcpy(&outputArr, message, message.count);
        MIDIPacketListAdd(&packetList, Int(packetList.numPackets), packet, 0, message.count, outputArr)
        let destinationCount = MIDIGetNumberOfDestinations()
        for i in 0...destinationCount - 1 {
            MIDISend(outputPort, MIDIGetDestination(i), &packetList)
        }
        
    }
    
    
}
