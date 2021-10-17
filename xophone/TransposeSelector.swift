//
//  NumberSelector.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 27/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct TransposeSelector: View {
    @Binding var value: Int
    var minimum = -48
    var maximum = 48
    let buttonWidth = CGFloat(40)
    let buttonColor = MonoleapAssets.controlColor.opacity(0.5)
    var body: some View {
        
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.minimum = NSNumber(value: minimum)
            formatter.maximum = NSNumber(value: maximum)
            formatter.numberStyle = .decimal
            return formatter
        }()
        
        HStack(spacing: 0) {
            Button(action: {
                if value - 12 >= minimum {
                    value -= 12
                }
            }) {
                Image("t_minus_12")
            }.frame(width: buttonWidth, height: 35).background(MonoleapAssets.sectionBackground).font(.system(size: 20).bold()).foregroundColor(buttonColor).padding([.top, .bottom], 5).contentShape(Rectangle())
            Button(action: {
                if value - 1 >= minimum {
                    value -= 1
                }
            }) {
                Image("t_minus_1")
            }.padding([.top, .bottom], 5).frame(width: buttonWidth, height: 35).background(MonoleapAssets.sectionBackground).font(.system(size: 20).bold()).foregroundColor(buttonColor).contentShape(Rectangle())
            
            TextField("", value: $value, formatter: formatter).frame(minWidth: 60, maxWidth: 60, maxHeight: .infinity).multilineTextAlignment(.center).padding(0).border(MonoleapAssets.controlColor.opacity(0.2))
            Button(action: {
                if value + 1 <= maximum {
                    value += 1
                }
            }) {
                Image("t_plus_1")
            }.padding([.top, .bottom], 5).frame(width: buttonWidth, height: 35).background(MonoleapAssets.sectionBackground).font(.system(size: 20).bold()).foregroundColor(buttonColor).contentShape(Rectangle())
            Button(action: {
                if value + 12 <= maximum {
                    value += 12
                }
            }) {
                Image("t_plus_12")
            }.padding([.top, .bottom], 5).frame(width: buttonWidth, height: 35).background(MonoleapAssets.sectionBackground).font(.system(size: 20).bold()).foregroundColor(buttonColor).contentShape(Rectangle())
        }.frame(height: 40).overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(MonoleapAssets.controlColor))
    }
}

//struct NumberSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        NumberSelector()
//    }
//}
