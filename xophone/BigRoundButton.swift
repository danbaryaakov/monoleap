//
//  BigRoundButton.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//
import SwiftUI

struct BigRoundButtonStyle: ButtonStyle {
    
    var image: String
    var size: CGFloat = 130.0
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .center) {
            Circle().fill(MonoleapAssets.sectionBackground)
            Circle().strokeBorder(MonoleapAssets.linearGradientTopBottom)
            Circle().fill(MonoleapAssets.sectionBackground).shadow(color: .black.opacity(0.75), radius: 4, x: 0, y: 4).shadow(color: .white.opacity(0.2), radius: 3, x: 0, y: -2).frame(width: 90, height: 90)
            Image(image)
            if (configuration.isPressed) {
                Circle().fill(.black.opacity(0.4))
            }
        }.frame(width: size, height: size)
    }
}

struct BigRoundButton: View {
    var image: String
    var size: CGFloat = 130.0
    var body: some View {
        ZStack(alignment: .center) {
            Circle().fill(MonoleapAssets.sectionBackground)
            Circle().strokeBorder(MonoleapAssets.linearGradientTopBottom)
            Circle().fill(MonoleapAssets.sectionBackground).shadow(color: .black.opacity(0.75), radius: 4, x: 0, y: 4).shadow(color: .white.opacity(0.15), radius: 2, x: 0, y: -2).frame(width: 90, height: 90)
            Image(image)
        }.frame(width: size, height: size)
    }
}
