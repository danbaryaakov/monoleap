//
//  InstrumentSettingsPage.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct InstrumentSettingsPage: View {
    
    @AppStorage(Settings.isSynthEnabled.key) private var isSynthEnabled = Settings.isSynthEnabled.defaultValue
    @AppStorage(Settings.showPatternGuides.key) private var showPatternGuides = Settings.showPatternGuides.defaultValue
    @AppStorage(Settings.calibrationEnabled.key) private var calibrationEnabled = Settings.calibrationEnabled.defaultValue
    @AppStorage(Settings.isRightHanded.key) private var isRightHanded = Settings.isRightHanded.defaultValue
    @AppStorage(Settings.fingeringScheme.key) private var fingeringScheme = Settings.fingeringScheme.defaultValue
    @AppStorage(Settings.transpose.key) private var transpose = Settings.transpose.defaultValue
    
    let options = FingeringSchemeManager.instance.allKeys.map{DropdownOption(key: $0, value: $0)}
    
    var body: some View {
      
        SettingsSection(image: "settings_icon", label: "General") {
            Toggle("Internal Synth", isOn: $isSynthEnabled).toggleStyle(MonoleapToggleStyle())
            Toggle("Show Pattern Guides", isOn: $showPatternGuides).toggleStyle(MonoleapToggleStyle())
            Toggle("Calibration Enabled", isOn: $calibrationEnabled).toggleStyle(MonoleapToggleStyle())
            Toggle("Leading Hand", isOn: $isRightHanded).toggleStyle(MonoleapToggleStyle(offText: "Left", onText: "Right"))
            
            if FeatureFlags.alternateFingeringSchemes {
                HStack {
                    Text("Fingering Scheme")
                    Spacer()
                    DropdownSelector(
                        selectedOption: options.filter{$0.key == fingeringScheme}.first ?? options[0],
                        placeholder: "Fingering Scheme",
                        options: options,
                        onOptionSelected: { option in
                            fingeringScheme = option.key
                        }).zIndex(2.0).frame(width: 140)
                }.zIndex(1.0)
            }
            
            HStack {
                Text("Transpose")
                Spacer()
                TransposeSelector(value: $transpose)
            }
            if FeatureFlags.playingSensitivity {
                HStack {
                    Text("Playing Sensitivity")
                    Spacer()
                    SensitivitySelector()
                }
            }
        }.zIndex(1.0)
        SettingsSection(image: "scale_icon", label: "Scale") {
            ScaleSelector()
        }
    }
}

struct InstrumentSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentSettingsPage()
    }
}
