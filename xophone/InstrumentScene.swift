//
//  InstrumentScene.swift
//  monoleap
//
//  Created by Omer Elimelech on 16/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import CoreMIDI

class InstrumentScene: SKScene {
    
    var client: MIDIClientRef!
    var outputPort: MIDIPortRef!
    
    var playedNote: Int? = nil
    var frequencies: Array<Any>?
    var previousArgs: Array<Any>?
    
    var left, right: Array<Any>?
    
    var volume, another, pitchBend: Byte?
    
    var fingetWidth: Float?
    var prevNote: Int?
    
    var theme: Theme?
//
//    var leftXCtrlValue, leftYCtrlValue, rightYCtrlValue, rightXCtrlValue, leftXCurrent, leftYCurrent, rightXCurrent, rightYCurrent: Int?
//
//    var pitchBendEnabled, keySwitchEnabled, velocityEnabled, leftXCtrlEnabled, leftYCtrlEnabled, rightXCtrlEnabled, rightYCtrlEnabled, isTouchesEnded, PDEnabled, isInvalidPattern: Bool?
    
    var synthEnabled: Bool?
    var isLeftMuted, isRightMuted: Bool?
    
    var rectFingerOneLeft: SKSpriteNode?
    var rectFingerTwoLeft: SKSpriteNode?
    var rectFingerThreeLeft: SKSpriteNode?
    var rectFingerFourLeft: SKSpriteNode?

    var rectFingerOneRight: SKSpriteNode?
    var rectFingerTwoRight: SKSpriteNode?
    var rectFingerThreeRight: SKSpriteNode?
    var rectFingerFourRight: SKSpriteNode?
    
    var midiConnector: MIDIConnector!
    
    let settings: SettingsManager = SettingsManager.sharedInstance
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        MIDIClientCreate("Xophone" as CFString, nil, nil, &client)
        MIDIOutputPortCreate(client, "Xophone Output Port" as CFString,  &outputPort)
        
        self.midiConnector = MIDIConnector.sharedInstance
        self.left = Array<Any>()
        self.right = Array<Any>()
    
        isRightMuted = false
        isLeftMuted = false
        
        if theme == nil {
            self.theme = Theme()
         //   theme?.apply(to: self)
        }
        
        
    }
}
