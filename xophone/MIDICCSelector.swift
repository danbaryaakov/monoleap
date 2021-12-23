//
//  MIDICCSelector.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 25/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct MIDICCSelector: View {
    
    var label: String = ""
    
    @Binding var value: Int
    
    var body: some View {
        HStack(spacing: 20) {
            Text(label)
            Spacer()
            NumberSelector(selectedNumber: $value, minimum: 0, maximum: 127)
            Button("TRANSMIT") {
                for i in 0...127 {
                    MIDIConnector.instance.sendControllerChange(Int(value), value: i, inChannel: Settings.midiChannel.value - 1)
                }
            }.padding(10).frame(width: 140).foregroundColor(MonoleapAssets.controlColor).overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(MonoleapAssets.controlColor))
        }
    }
    
}

struct MIDICCSelector_Previews: PreviewProvider {
    @State var value: Int = 5

    static var previews: some View {
        MIDICCSelector(value: .constant(5))
    }
}
