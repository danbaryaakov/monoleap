//
//  MIDISettingsPage.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct MIDISettingsPage: View {
    
    @State private var isMIDIEnabled = true
    @AppStorage(Settings.isMidiEnabled.key) private var isMidiEnabled = Settings.isMidiEnabled.defaultValue
    @AppStorage(Settings.midiChannel.key) private var midiChannel = Settings.midiChannel.defaultValue
    
    @AppStorage(Settings.leftXCtrlEnabled.key) private var leftXCtrlEnabled = Settings.leftXCtrlEnabled.defaultValue
    @AppStorage(Settings.leftXCtrlValue.key) private var leftXCtrlValue = Settings.leftXCtrlValue.defaultValue
    @AppStorage(Settings.leftYCtrlEnabled.key) private var leftYCtrlEnabled = Settings.leftYCtrlEnabled.defaultValue
    @AppStorage(Settings.leftYCtrlValue.key) private var leftYCtrlValue = Settings.leftYCtrlValue.defaultValue
    
    @AppStorage(Settings.rightXCtrlEnabled.key) private var rightXCtrlEnabled = Settings.rightXCtrlEnabled.defaultValue
    @AppStorage(Settings.rightXCtrlValue.key) private var rightXCtrlValue = Settings.rightXCtrlValue.defaultValue
    @AppStorage(Settings.rightYCtrlValue.key) private var rightYCtrlValue = Settings.rightYCtrlValue.defaultValue
    @AppStorage(Settings.rightYCtrlEnabled.key) private var rightYCtrlEnabled = Settings.rightYCtrlEnabled.defaultValue
    
    var body: some View {
        SettingsSection(image: "midi_icon", label: "General") {
            Toggle("MIDI Enabled", isOn: $isMidiEnabled).toggleStyle(MonoleapToggleStyle())
            HStack {
                Text("MIDI Channel")
                Spacer()
                NumberSelector(selectedNumber: $midiChannel, minimum: 1, maximum: 16)
            }
        }
        SettingsSection(image: "right_hand_icon", label: "Right Hand") {
            Toggle("X CC Enabled", isOn: $rightXCtrlEnabled).toggleStyle(MonoleapToggleStyle())
            MIDICCSelector(label: "X CC Value", value: $rightXCtrlValue)
            Toggle("Y CC Enabled", isOn: $rightYCtrlEnabled).toggleStyle(MonoleapToggleStyle())
            MIDICCSelector(label: "Y CC Value", value: $rightYCtrlValue)
        }
        SettingsSection(image: "left_hand_icon", label: "Left Hand") {
            Toggle("X CC Enabled", isOn: $leftXCtrlEnabled).toggleStyle(MonoleapToggleStyle())
            MIDICCSelector(label: "X CC Value", value: $leftXCtrlValue)
            Toggle("Y CC Enabled", isOn: $leftYCtrlEnabled).toggleStyle(MonoleapToggleStyle())
            MIDICCSelector(label: "Y CC Value", value: $leftYCtrlValue)
        }
    }
}

struct MIDISettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        MIDISettingsPage()
    }
}
