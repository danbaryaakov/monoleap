//
//  Settings.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 23/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

enum PlayingDifficulty : String {
    case easy = "EASY"
    case normal = "NORMAL"
    case pro = "PRO"
}

struct Setting<Element> {
    let key: String
    let defaultValue: Element
    var value: Element {
        get {
            return UserDefaults.standard.object(forKey: key) as? Element ?? defaultValue
        }
        set {
            print("Setting \(key) changed to \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

struct Settings {
    
    // instrument
    static var isSynthEnabled = Setting(key: "SynthEnabled", defaultValue: true)
    static var isLeftHanded = Setting(key: "IS_RIGHT_HANDED", defaultValue: true)
    
    static var scale = Setting(key: "SCALE", defaultValue: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    static var scaleRoot = Setting(key: "SCALE_ROOT", defaultValue: 0)
    static var fingerWidth = Setting(key: "FINGER_WIDTH", defaultValue: 130.0)
    static var playingDifficulty = Setting(key: "PLAYING_DIFFICULTY", defaultValue: PlayingDifficulty.normal)
    
    // theme
    static var selectedTheme = Setting(key: "selectedTheme", defaultValue: "SPARK")
    
    // midi
    static var midiChannel = Setting(key: "MIDI_CHANNEL", defaultValue: 1)
    
    static var leftXCtrlEnabled = Setting(key: "leftXCtrlEnabled", defaultValue: false)
    static var leftXCtrlValue = Setting(key: "leftXCtrlValue", defaultValue: 20)
    static var leftYCtrlEnabled = Setting(key: "leftYCtrlEnabled", defaultValue: true)
    static var leftYCtrlValue = Setting(key: "leftYCtrlValue", defaultValue: 71)
    
    static var rightXCtrlEnabled = Setting(key: "rightXCtrlEnabled", defaultValue: false)
    static var rightXCtrlValue = Setting(key: "rightXCtrlValue", defaultValue: 40)
    static var rightYCtrlEnabled = Setting(key: "rightYCtrlEnabled", defaultValue: true)
    static var rightYCtrlValue = Setting(key: "rightYCtrlValue", defaultValue: 71)
    
}
