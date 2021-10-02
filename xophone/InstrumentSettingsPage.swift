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
    
    var body: some View {
        SettingsSection(image: "settings_icon", label: "General") {
            Toggle("Internal Synth", isOn: $isSynthEnabled).toggleStyle(MonoleapToggleStyle())
            Spacer().frame(height: 10)
            Toggle("Show Pattern Guides", isOn: $showPatternGuides).toggleStyle(MonoleapToggleStyle())
            Toggle("Calibration Enabled", isOn: $calibrationEnabled).toggleStyle(MonoleapToggleStyle())
            Spacer().frame(height: 10)
//            Toggle("Leading Hand", isOn: $isRightHanded).toggleStyle(MonoleapToggleStyle(offText: "Left", onText: "Right"))
        }
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
