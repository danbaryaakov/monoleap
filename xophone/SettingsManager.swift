//
//  SettingsManager.swift
//  monoleap
//
//  Created by Omer Elimelech on 16/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {
    
    static let sharedInstance = SettingsManager()
    
    var themeName: String? {
        return DefaultsManager.themeName
    }
    var leftXCtrlValue: Int? {
        return DefaultsManager.leftXCtrlValue
    }
    var leftYCtrlValue: Int? {
        return DefaultsManager.leftYCtrlValue
    }
    var rightYCtrlValue: Int? {
        return DefaultsManager.rightYCtrlValue
    }
    var rightXCtrlValue: Int? {
        return DefaultsManager.rightXCtrlValue
    }
    var leftXCtrlEnabled: Bool? {
        return DefaultsManager.leftXCtrlEnabled
    }
    var leftYCtrlEnabled: Bool? {
        return DefaultsManager.leftYCtrlEnabled
    }
    var rightXCtrlEnabled: Bool? {
        return DefaultsManager.rightXCtrlEnabled
    }
    var rightYCtrlEnabled: Bool? {
        return DefaultsManager.rightYCtrlEnabled
    }
    var pitchBendEnabled: Bool? {
        return DefaultsManager.pitchBendEnabled
    }
    var keySwitchEnabled: Bool? {
        return DefaultsManager.keySwitchEnabled
    }
    var velocityEnabled: Bool? {
        return DefaultsManager.velocityEnabled
    }
    var midiOutChannel: String? {
        return DefaultsManager.midiOutChannel
    }
    var synthEnabled: Bool? {
        return DefaultsManager.synthEnabled
    }
    var fingerWidth: Float? {
        return DefaultsManager.fingerWidth
    }
}

class DefaultsManager: NSObject {
    static let defaults = UserDefaults.standard
    struct Constants {
        static let leftXCtrlValue = "leftXCtrlValue"
        static let leftYCtrlValue = "leftYCtrlValue"
        static let rightYCtrlValue = "rightYCtrlValue"
        static let rightXCtrlValue = "rightXCtrlValue"
        static let pitchBendEnabled = "pitchBendEnabled"
        static let keySwitchEnabled = "keySwitchEnabled"
        static let velocityEnabled = "velocityEnabled"
        
        
        static let rightXCtrlEnabled = "rightXCtrlEnabled"
        static let rightYCtrlEnabled = "rightYCtrlEnabled"
        static let leftXCtrlEnabled = "leftXCtrlEnabled"
        static let leftYCtrlEnabled = "leftYCtrlEnabled"
        
        static let midiOutChannel = "midiOutChannel"
        static let synthEnabled = "SynthEnabled"
        
        static let themeName = "themeName"
        static let fingerWidth = "fingerWidth"
    }
    
    static var leftXCtrlValue: Int {
        get { return defaults.value(forKey: Constants.leftXCtrlValue) as? Int ?? 1 }
        set { defaults.setValue(newValue, forKey: Constants.leftXCtrlValue)}
    }
    
    static var leftYCtrlValue: Int {
        get { return defaults.value(forKey: Constants.leftYCtrlValue) as? Int ?? 71 }
        set { defaults.setValue(newValue, forKey: Constants.leftYCtrlValue)}
    }
    
    static var rightYCtrlValue: Int {
        get { return defaults.value(forKey: Constants.rightYCtrlValue) as? Int ?? 74 }
        set { defaults.setValue(newValue, forKey: Constants.rightYCtrlValue)}
    }
    
    static var rightXCtrlValue: Int {
        get { return defaults.value(forKey: Constants.rightXCtrlValue) as? Int ?? 12 }
        set { defaults.setValue(newValue, forKey: Constants.rightXCtrlValue)}
    }
    
    static var pitchBendEnabled: Bool {
        get { return defaults.value(forKey: Constants.pitchBendEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.pitchBendEnabled)}
    }
    
    static var keySwitchEnabled: Bool {
        get { return defaults.value(forKey: Constants.keySwitchEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.keySwitchEnabled)}
    }
    
    static var velocityEnabled: Bool {
        get { return defaults.value(forKey: Constants.velocityEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.velocityEnabled)}
    }

    static var rightXCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.rightXCtrlEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.rightXCtrlEnabled)}
    }
    
    static var rightYCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.rightYCtrlEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.rightYCtrlEnabled)}
    }
    
    static var leftXCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.leftXCtrlEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.leftXCtrlEnabled)}
    }
    
    static var leftYCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.leftYCtrlEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.leftYCtrlEnabled)}
    }
    
    static var midiOutChannel: String {
        get { return defaults.value(forKey: Constants.midiOutChannel) as? String ?? "1" }
        set { defaults.setValue(newValue, forKey: Constants.midiOutChannel)}
    }
    
    static var synthEnabled: Bool {
        get { return defaults.value(forKey: Constants.synthEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.synthEnabled)}
    }
    
    static var themeName: String {
        get { return defaults.value(forKey: Constants.themeName) as? String ?? "Basic" }
        set { defaults.setValue(newValue, forKey: Constants.themeName)}
    }
    
    static var fingerWidth: Float {
        get { return defaults.value(forKey: Constants.fingerWidth) as? Float ?? 136.0 }
        set { defaults.setValue(newValue, forKey: Constants.fingerWidth)}
    }

}
