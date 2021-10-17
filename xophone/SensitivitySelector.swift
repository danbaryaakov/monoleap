//
//  SensitivitySelector.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 16/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

struct SensitivitySelector: View {
    
    @AppStorage(Settings.playingSensitivity.key) private var selectedValue = Settings.playingSensitivity.defaultValue
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(PlayingSensitivity.allCases.indices, id: \.self) { index in
                let sensitivity = PlayingSensitivity.allCases[index]
                ZStack {
                    if sensitivity == selectedValue {
                        MonoleapAssets.rect(topLeftRadius: index == 0 ? 10 : 0, topRightRadius: index == PlayingSensitivity.allCases.count - 1 ? 10 : 0, bottomLeftRadius: index == 0 ? 10 : 0, bottomRightRadius: index == PlayingSensitivity.allCases.count - 1 ? 10 : 0).stroke(MonoleapAssets.controlColor).frame(width: 70, height: 35).onTapGesture {
                            selectedValue = sensitivity
                        }
                        MonoleapAssets.rect(topLeftRadius: index == 0 ? 10 : 0, topRightRadius: index == PlayingSensitivity.allCases.count - 1 ? 10 : 0, bottomLeftRadius: index == 0 ? 10 : 0, bottomRightRadius: index == PlayingSensitivity.allCases.count - 1 ? 10 : 0).fill(MonoleapAssets.controlColor).frame(width: 70, height: 35).onTapGesture {
                            selectedValue = sensitivity
                        }
                    } else {
                        MonoleapAssets.rect(topLeftRadius: index == 0 ? 10 : 0, topRightRadius: index == PlayingSensitivity.allCases.count - 1 ? 10 : 0, bottomLeftRadius: index == 0 ? 10 : 0, bottomRightRadius: index == PlayingSensitivity.allCases.count - 1 ? 10 : 0).stroke(MonoleapAssets.controlColor).frame(width: 70, height: 35).onTapGesture {
                            selectedValue = sensitivity
                        }
                    }
                    Text(sensitivity.rawValue).foregroundColor(sensitivity == selectedValue ? .white : MonoleapAssets.controlColor).onTapGesture {
                        selectedValue = sensitivity
                    }
                }
                    
            }
        }.font(.system(size: 13))
    }
}

//struct SensitivitySelector_Previews: PreviewProvider {
//    static var previews: some View {
//        SensitivitySelector()
//    }
//}
