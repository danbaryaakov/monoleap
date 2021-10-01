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
    
    var body: some View {
        SettingsSection(image: "settings_icon", label: "General") {
            Toggle("Internal Synth", isOn: $isSynthEnabled).toggleStyle(MonoleapToggleStyle())
            Toggle("Show Pattern Guides", isOn: $showPatternGuides).toggleStyle(MonoleapToggleStyle())
//            Toggle("Hand Size Calibration", isOn: $isHandSizeCalibrationEnabled).toggleStyle(MonoleapToggleStyle())
//
//            Toggle("Show Pattern Guides", isOn: $isPatternGuidesEnabled).toggleStyle(MonoleapToggleStyle())
        }
        SettingsSection(image: "settings_icon", label: "Scale") {
//            ScaleSelector()
        }
    }
}

struct InstrumentSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        InstrumentSettingsPage()
    }
}
