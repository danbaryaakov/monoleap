//
//  SKTextureGradient.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 05/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import SpriteKit

extension SKTexture {
    
    convenience init(verticalGradientofSize size: CGSize, topColor: CIColor, bottomColor: CIColor) {
        let coreImageContext = CIContext(options: nil)
        let gradientFilter = CIFilter(name: "CILinearGradient")
        gradientFilter?.setDefaults()
        let startVector = CIVector(x: 0, y: -size.height / 2)
        let endVector = CIVector(x: 0, y: size.height / 2)
        gradientFilter?.setValue(startVector, forKey: "inputPoint0")
        gradientFilter?.setValue(endVector, forKey: "inputPoint1")
        gradientFilter?.setValue(bottomColor, forKey: "inputColor0")
        gradientFilter?.setValue(topColor, forKey: "inputColor1")
        let cgimg = coreImageContext.createCGImage((gradientFilter?.outputImage!)!, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(image: UIImage(cgImage: cgimg!))
    }
    
}
