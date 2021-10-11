//
//  NumberSelector.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 27/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct NumberSelector: View {
    @Binding var selectedNumber: Int
    var minimum = 0
    var maximum = 10
    var interval = 1
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
                if selectedNumber - interval >= minimum {
                    selectedNumber -= interval
                }
            }) {
                Image(systemName: "minus")
            }.frame(width: 60, height: 40).background(MonoleapAssets.sectionBackground).font(.system(size: 20).bold()).foregroundColor(MonoleapAssets.controlColor).contentShape(Rectangle())
            TextField("", value: $selectedNumber, formatter: formatter).frame(minWidth: 80, maxWidth: 80, maxHeight: .infinity).multilineTextAlignment(.center).padding(0).border(MonoleapAssets.controlColor.opacity(0.2))
            Button(action: {
                if selectedNumber + interval <= maximum {
                    selectedNumber += interval
                }
            }) {
                Image(systemName: "plus")
            }.frame(width: 60, height: 40).background(MonoleapAssets.sectionBackground).font(.system(size: 20).bold()).foregroundColor(MonoleapAssets.controlColor).contentShape(Rectangle())
        }.frame(height: 40).overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(MonoleapAssets.controlColor))
    }
}

//struct NumberSelector_Previews: PreviewProvider {
//    static var previews: some View {
//        NumberSelector()
//    }
//}
