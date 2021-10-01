//
//  ThemeSettingsPage.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct ThemeSettingsPage: View {
    var body: some View {
        VStack {
            ScrollView {
            }
        }.overlay(RoundedRectangle(cornerRadius:10).strokeBorder(MonoleapAssets.controlColor)).padding([.top, .leading, .trailing], 30)
    }
}

struct ThemeSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSettingsPage()
    }
}
