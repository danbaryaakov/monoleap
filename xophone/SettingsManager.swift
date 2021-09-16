//
//  SettingsManager.swift
//  monoleap
//
//  Created by Omer Elimelech on 16/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

class SettingsManager: NSObject {
    @objc static let sharedInstance = SettingsManager()
    
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
    
    @objc static var leftXCtrlValue: Int {
        get { return defaults.value(forKey: Constants.leftXCtrlValue) as? Int ?? 1 }
        set { defaults.setValue(newValue, forKey: Constants.leftXCtrlValue)}
    }
    
    @objc static var leftYCtrlValue: Int {
        get { return defaults.value(forKey: Constants.leftYCtrlValue) as? Int ?? 71 }
        set { defaults.setValue(newValue, forKey: Constants.leftYCtrlValue)}
    }
    
    @objc static var rightYCtrlValue: Int {
        get { return defaults.value(forKey: Constants.rightYCtrlValue) as? Int ?? 74 }
        set { defaults.setValue(newValue, forKey: Constants.rightYCtrlValue)}
    }
    
    @objc  static var rightXCtrlValue: Int {
        get { return defaults.value(forKey: Constants.rightXCtrlValue) as? Int ?? 12 }
        set { defaults.setValue(newValue, forKey: Constants.rightXCtrlValue)}
    }
    
    @objc static var pitchBendEnabled: Bool {
        get { return defaults.value(forKey: Constants.pitchBendEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.pitchBendEnabled)}
    }
    
    @objc static var keySwitchEnabled: Bool {
        get { return defaults.value(forKey: Constants.keySwitchEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.keySwitchEnabled)}
    }
    
    @objc static var velocityEnabled: Bool {
        get { return defaults.value(forKey: Constants.velocityEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.velocityEnabled)}
    }

    @objc static var rightXCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.rightXCtrlEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.rightXCtrlEnabled)}
    }
    
    @objc static var rightYCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.rightYCtrlEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.rightYCtrlEnabled)}
    }
    
    @objc static var leftXCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.leftXCtrlEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.leftXCtrlEnabled)}
    }
    
    @objc static var leftYCtrlEnabled: Bool {
        get { return defaults.value(forKey: Constants.leftYCtrlEnabled) as? Bool ?? true }
        set { defaults.setValue(newValue, forKey: Constants.leftYCtrlEnabled)}
    }
    
    @objc static var midiOutChannel: String {
        get { return defaults.value(forKey: Constants.midiOutChannel) as? String ?? "1" }
        set { defaults.setValue(newValue, forKey: Constants.midiOutChannel)}
    }
    
    @objc static var synthEnabled: Bool {
        get { return defaults.value(forKey: Constants.synthEnabled) as? Bool ?? false }
        set { defaults.setValue(newValue, forKey: Constants.synthEnabled)}
    }
    
    @objc static var themeName: String {
        get { return defaults.value(forKey: Constants.themeName) as? String ?? "Basic" }
        set { defaults.setValue(newValue, forKey: Constants.themeName)}
    }
    
    @objc static var fingerWidth: Float {
        get { return defaults.value(forKey: Constants.fingerWidth) as? Float ?? 136.0 }
        set { defaults.setValue(newValue, forKey: Constants.fingerWidth)}
    }

}
