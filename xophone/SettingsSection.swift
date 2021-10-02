//
//  SettingsSection.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct SettingsSection<Content: View>: View {

    var image: String = "settings_icon"
    var label: String = "Settings"
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).stroke(MonoleapAssets.controlColor)
            HStack(alignment: .center) {
                VStack(spacing: 0) {
                    Spacer()
                    Image(image).resizable().scaledToFit().foregroundColor(.white).frame(width: 30)
                    HStack {
                        Spacer()
                        Text(label).foregroundColor(.white).frame(height: 50).font(.system(size: 12).weight(.bold))
                        Spacer()
                    }
                    Spacer()
                }.background(MonoleapAssets.controlColor.opacity(0.2)).frame(maxWidth: .infinity).clipShape(MonoleapAssets.rect(topLeftRadius: 10, bottomLeftRadius: 10)).frame(width: 100)
                VStack(alignment: .leading, spacing: 15) {
                    content
                }.padding([.leading, .trailing], 30).padding([.top, .bottom], 15).frame(minWidth: 200, maxWidth: .infinity)
                
            }.zIndex(1.0)
        }.background(MonoleapAssets.sectionBackground).frame(maxWidth: .infinity).padding([.leading, .trailing], 30).padding(.top, 15)
    }
    
}

//
//struct SettingsSection_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsSection()
//    }
//}
