//
//  Theme.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import SpriteKit

public protocol Theme {
    
    func apply(to: SKScene)
    func verticalRightChanged(_ position: Int)
    func verticalLeftChanged(_ position: Int)
    func drawLeftHandTouches(pattern: Int, touches: [UITouch])
    func drawRightHandTouches(pattern: Int, touches: [UITouch])
    func leftHandMoved(touches: [UITouch], pattern: Int)
    func rightHandMoved(touches: [UITouch], pattern: Int)
}
