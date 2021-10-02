//
//  ThemeSettingsPage.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct ThemeSettingsPage: View {
    
    @AppStorage(Settings.selectedTheme.key) var selectedTheme = Settings.selectedTheme.defaultValue
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
//        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
//            ScrollView {
                Spacer()
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(ThemeManager.instance.getAllThemes(), id: \.self) { theme in
                        VStack (spacing: 0) {
                            Image(theme.image).resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 10)).overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(MonoleapAssets.controlColor.opacity(0.2))).padding(20).opacity(0.6)
                            
                            Text(theme.name).font(.system(size: 12).bold()).frame(maxWidth: .infinity, maxHeight: .infinity).padding(10).background(theme.key == selectedTheme ? MonoleapAssets.controlColor : MonoleapAssets.controlColor.opacity(0.1))
                                .clipShape(MonoleapAssets.rect(bottomLeftRadius: 10, bottomRightRadius: 10))
                            
                        }.onTapGesture {
                            selectedTheme = theme.key
                        }.onLongPressGesture {
                            selectedTheme = theme.key
                        }.overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(theme.key == selectedTheme ? MonoleapAssets.controlColor : MonoleapAssets.controlColor.opacity(0.5))).padding([.leading, .trailing], 10)
                    }
                }.padding(30)
                Spacer()
//            }
        }.background(MonoleapAssets.sectionBackground).overlay(RoundedRectangle(cornerRadius:10).strokeBorder(MonoleapAssets.controlColor)).padding([.leading, .trailing], 30).padding(.top, 15)
    }
}

struct ThemeSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSettingsPage()
    }
}
