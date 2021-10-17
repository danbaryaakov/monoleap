//
//  Settings.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 23/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

//
//extension Array: RawRepresentable where Element: Codable {
//    public init?(rawValue: String) {
//        guard let data = rawValue.data(using: .utf8),
//              let result = try? JSONDecoder().decode([Element].self, from: data)
//        else {
//            return nil
//        }
//        self = result
//    }
//
//    public var rawValue: String {
//        guard let data = try? JSONEncoder().encode(self),
//              let result = String(data: data, encoding: .utf8)
//        else {
//            return "[]"
//        }
//        return result
//    }
//}

public enum PlayingSensitivity : String, CaseIterable {
    case low = "Low"
    case normal = "Normal"
    case high = "High"
    case extreme = "Extreme"
    
    func initialDebounceValue() -> Double {
        switch self {
        case .low:
            return 30.0
        case .normal:
            return 15.0
        case .high:
            return 5.0
        case .extreme:
            return 0.0
        }
    }
    
    func debounceValue() -> Double {
        switch self {
        case .low:
            return 90.0
        case.normal:
            return 45.0
        case .high:
            return 25.0
        case .extreme:
            return 0.0
        }
    }
    
}

protocol CanRestoreDefault {
    func restoreDefault()
}

struct Setting<Element> : CanRestoreDefault {
    let key: String
    let defaultValue: Element
    var observer: (() -> ())? = nil
    
    var value: Element {
        get {
            return UserDefaults.standard.object(forKey: key) as? Element ?? defaultValue
        }
        set {
            print("Setting \(key) changed to \(newValue)")
            UserDefaults.standard.setValue(newValue, forKey: key)
            observer?()
        }
    }
    func restoreDefault() {
        UserDefaults.standard.setValue(defaultValue, forKey: key)
        observer?()
    }
    
    mutating func onChange(_ observer: @escaping () -> ()) {
        self.observer = observer
    }
}

struct Settings {
    
    static var allSettings: [CanRestoreDefault] = []
    
    // instrument
    static var isSynthEnabled = add(key: "SynthEnabled", defaultValue: true)
    static var showPatternGuides = add(key: "SHOW_PATTERN_GUIDES", defaultValue: true)
    static var calibrationEnabled = add(key: "CALIBRATION_ENABLED", defaultValue: true)
    
    static var isRightHanded = add(key: "IS_RIGHT_HANDED", defaultValue: true)
    
    static var scale = add(key: "SCALE", defaultValue: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
    static var scaleRoot = add(key: "SCALE_ROOT", defaultValue: 0)
    static var fingerWidth = add(key: "FINGER_WIDTH", defaultValue: 130.0)
    static var playingSensitivity = add(key: "PLAYING_SENSITIVITY", defaultValue: PlayingSensitivity.normal)
    
    static var fingeringScheme = add(key: "FINGERING_SCHEME", defaultValue: "Default")
    static var transpose = add(key: "TRANSPOSE", defaultValue: 0)
    
    static var debounceValue = add(key: "DEBOUNCE", defaultValue: 50.0)
    static var initialDebounceValue = add(key: "INITIAL_DEBOUNCE", defaultValue: 15.0)
    
    // theme
    static var selectedTheme = add(key: "selectedTheme", defaultValue: "SPARK")
    
    // midi
    static var isMidiEnabled = add(key: "MIDI_ENABLED", defaultValue: true)
    static var midiChannel = add(key: "MIDI_CHANNEL", defaultValue: 1)
    
    static var leftXCtrlEnabled = add(key: "leftXCtrlEnabled", defaultValue: false)
    static var leftXCtrlValue = add(key: "leftXCtrlValue", defaultValue: 20)
    static var leftYCtrlEnabled = add(key: "leftYCtrlEnabled", defaultValue: true)
    static var leftYCtrlValue = add(key: "leftYCtrlValue", defaultValue: 71)
    
    static var rightXCtrlEnabled = add(key: "rightXCtrlEnabled", defaultValue: false)
    static var rightXCtrlValue = add(key: "rightXCtrlValue", defaultValue: 40)
    static var rightYCtrlEnabled = add(key: "rightYCtrlEnabled", defaultValue: true)
    static var rightYCtrlValue = add(key: "rightYCtrlValue", defaultValue: 74)
    
    static func restoreAllDefaults() {
        for setting in allSettings {
            setting.restoreDefault()
        }
    }
    
    static func add<T>(key: String, defaultValue: T) -> Setting<T> {
        let setting = Setting(key: key, defaultValue: defaultValue)
        allSettings.append(setting)
        return setting
    }
    
    static func getPlayingSensitivity() -> PlayingSensitivity {
        if !FeatureFlags.playingSensitivity {
            return .normal
        }
        if let rawValue = UserDefaults.standard.string(forKey: Settings.playingSensitivity.key) {
            return PlayingSensitivity(rawValue: rawValue) ?? .normal
        }
        return .normal
    }
}
