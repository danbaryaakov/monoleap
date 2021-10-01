//
//  BigRoundButton.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//
import SwiftUI

struct BigRoundButton: View {
    var image: String
    var size: CGFloat = 100.0
    var body: some View {
        ZStack(alignment: .center) {
            Circle().fill(MonoleapAssets.dark_background).shadow(color: .black.opacity(0.75), radius: 4, x: 4, y: 4).shadow(color: .white.opacity(0.1), radius: 4, x: -2, y: -2).frame(width: size - 60, height: size - 60)
            Image(image)
        }.frame(width: size, height: size).overlay(Circle().strokeBorder(MonoleapAssets.linearGradientTopBottom))
    }
}
