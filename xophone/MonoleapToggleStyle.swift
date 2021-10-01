//
//  MonoleapToggleStyle.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 25/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct MonoleapToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        return HStack(spacing: 0) {
            configuration.label
            Spacer()
            ZStack {
                if !configuration.isOn {
                    MonoleapAssets.rect(topLeftRadius: 10, bottomLeftRadius: 10).fill(
                        MonoleapAssets.controlColor
                    ).frame(width: 70, height: 35)
                } else {
                    MonoleapAssets.rect(topLeftRadius: 10, bottomLeftRadius: 10).stroke(MonoleapAssets.controlColor).frame(width: 70, height: 35).contentShape(Rectangle())
                }
                Text("Off").foregroundColor(!configuration.isOn ? Color.white : MonoleapAssets.controlColor).fontWeight(.bold)
            }.onTapGesture {
                configuration.isOn = false
            }
            ZStack {
                if !configuration.isOn {
                    RoundedCorners(tl: 0, tr: 10, bl: 0, br: 10).stroke(MonoleapAssets.controlColor).frame(width: 70, height: 35).contentShape(Rectangle())
                } else {
                    MonoleapAssets.rect(topRightRadius: 10, bottomRightRadius: 10).fill(
                        MonoleapAssets.controlColor
                    ).frame(width: 70, height: 35)
                }
                Text("On").foregroundColor(configuration.isOn ? Color.white : MonoleapAssets.controlColor).fontWeight(.bold)
            }.onTapGesture {
                configuration.isOn = true
            }
        }
    }
}
