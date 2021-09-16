//
//  MidiConnectorImpl.swift
//  monoleap
//
//  Created by Omer Elimelech on 10/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
typealias Byte = UInt8
@objc protocol MidiConnectorImpl {
    func sendNote(on noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int)
    func sendNoteOff(_ noteNumber: Int, inChannel channel: Int, withVelocity velocity: Int)
    func sendControllerChange(_ ccNumber: Int, value: Int, inChannel channel: Int)
    func sendMidi(_ message: UnsafePointer<Byte>)
}
