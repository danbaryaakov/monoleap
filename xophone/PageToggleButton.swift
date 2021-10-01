//
//  PageToggleButton.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct PageToggleButton: View {
    var image: String
    var size: CGFloat = 80
    var label: String = "Instrument"
    var selected: Bool = false
    var showLabel:Bool = true
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                if selected {
                    Circle().fill(MonoleapAssets.dark_background).frame(width: size - 20, height: size - 20).overlay(Circle().fill(MonoleapAssets.radialGradient))
                } else {
                    Circle().fill(MonoleapAssets.dark_background).frame(width: size - 20, height: size - 20).overlay(Circle().strokeBorder(MonoleapAssets.controlColor.opacity(0.5)))
                }
                Image(image).resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(selected ? .white : MonoleapAssets.controlColor)
            }.frame(width: size, height: size).padding(.top, 10)
            if showLabel {
                Text(label).foregroundColor(MonoleapAssets.controlColor).font(Font.system(size: 8, weight: .bold)).padding(.bottom, 10)
            }
        }
    }
}
