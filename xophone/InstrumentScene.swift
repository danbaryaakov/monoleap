//
//  InstrumentScene.swift
//  monoleap
//
//  Created by Omer Elimelech on 16/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import CoreMIDI

class InstrumentScene1: SKScene {
    
    var playedNote: Int? = nil
    
    var previousArgs: Array<Any>?
    
    var left = [UITouch]()
    var right = [UITouch]()
    
    var volume, another, pitchBend: Byte?
    
    var fingerWidth: CGFloat!
    var prevNote: Int?
    
    var theme: Theme?

    var isLeftMuted, isRightMuted: Bool?
    
    var rectFingerOneLeft: SKSpriteNode?
    var rectFingerTwoLeft: SKSpriteNode?
    var rectFingerThreeLeft: SKSpriteNode?
    var rectFingerFourLeft: SKSpriteNode?

    var rectFingerOneRight: SKSpriteNode?
    var rectFingerTwoRight: SKSpriteNode?
    var rectFingerThreeRight: SKSpriteNode?
    var rectFingerFourRight: SKSpriteNode?
    
    var lastLeftTop, lastRightTop: CGFloat?
    var midiConnector: MIDIConnector!
    
    var leftYCurrent, leftXCurrent, rightYCurrent, rightXCurrent: Int?
    
    var isTouchesEnded, isInvalidPattern, PDEnabled: Bool?
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = SKColor(MonoleapAssets.dark_background)
        
        self.midiConnector = MIDIConnector.sharedInstance
        self.left = [UITouch]()
        self.right = [UITouch]()
    
        isRightMuted = false
        isLeftMuted = false
        
        theme = ThemeManager.instance.createCurrentTheme()
        theme?.apply(to: self)
        
        self.fingerWidth = SettingsManager.fingerWidth
        if SettingsManager.pitchBendEnabled {
            self.drawPitchBendArea()
        }
        
        let _ = SynthManager.instance
        
    }
    
    func drawPitchBendArea() {
        let rightColor: CIColor = CIColor(red: 248.0/255.0, green:182.0/255.0, blue:250.0/255.0, alpha:0.2)
        let leftColor: CIColor = CIColor(red: 248.0/255.0, green:182.0/255.0, blue:250.0/255.0, alpha:0.0)
        let tx = SKTexture.init(horizontalGradientofSize: CGSize(width: self.frame.size.width/8, height: self.frame.height), topColor: rightColor, bottomColor: leftColor)
        let backgroundGradient = SKSpriteNode(texture: tx)
        backgroundGradient.position = CGPoint(x: self.frame.width / 2 - self.frame.size.width / 16, y: self.frame.height / 2)
        self.addChild(backgroundGradient)
    }
    
    func drawPatternGuides() {
        let guideWidth: CGFloat = self.size.width / 2 - 20
        if left.count > 0 {
            let topRight = left.first
            let leftTop = topRight?.location(in: self.view).y ?? 0
            let leftPositionX = self.size.width / 4
            if rectFingerOneLeft == nil {
                rectFingerOneLeft = createGradientRect(width: guideWidth , height: fingerWidth)
                rectFingerTwoLeft = createGradientRect(width: guideWidth, height: fingerWidth)
                rectFingerThreeLeft = createGradientRect(width: guideWidth, height: fingerWidth)
                rectFingerFourLeft = createGradientRect(width: guideWidth, height: fingerWidth * 2)
                [rectFingerOneLeft, rectFingerTwoLeft, rectFingerThreeLeft, rectFingerFourLeft].forEach({addChild($0!)})
            }
            rectFingerOneLeft?.position = CGPoint(x: leftPositionX, y: self.size.height - leftTop)
            rectFingerTwoLeft?.position = CGPoint(x: leftPositionX, y: self.size.height - leftTop - fingerWidth)
            rectFingerThreeLeft?.position = CGPoint(x: leftPositionX, y: size.height - leftTop - fingerWidth * 2)
            rectFingerFourLeft?.position = CGPoint(x: leftPositionX, y: size.height - leftTop - fingerWidth * 3.5)
            
            [rectFingerOneLeft, rectFingerTwoLeft, rectFingerThreeLeft].forEach { node in
                node?.isHidden = false
                node?.size = CGSize(width: guideWidth , height: fingerWidth)
            }
            rectFingerFourLeft?.isHidden = false
            rectFingerFourLeft?.size = CGSize(width: guideWidth, height: fingerWidth * 2)
        } else {
            [rectFingerOneLeft, rectFingerTwoLeft, rectFingerThreeLeft, rectFingerFourLeft].forEach({$0?.isHidden = true})
        }

        if right.count > 0 {
            let touch = right.first
            let rightTop = touch?.location(in: self.view).y ?? 0

            if rectFingerOneRight == nil {
                rectFingerOneRight = createGradientRect(width: guideWidth, height: fingerWidth)
                rectFingerTwoRight = createGradientRect(width: guideWidth, height: fingerWidth)
                rectFingerThreeRight = createGradientRect(width: guideWidth, height: fingerWidth)
                rectFingerFourRight = createGradientRect(width: guideWidth, height: fingerWidth * 2)
                [rectFingerOneRight, rectFingerTwoRight, rectFingerThreeRight, rectFingerFourRight].forEach({addChild($0!)})
            }

            let rightPositionX = self.size.width * 3/4

            rectFingerOneRight?.position = CGPoint(x: rightPositionX, y: size.height - rightTop)
            rectFingerTwoRight?.position = CGPoint(x: rightPositionX, y: size.height - rightTop - fingerWidth)
            rectFingerThreeRight?.position = CGPoint(x: rightPositionX, y: size.height - rightTop - fingerWidth * 2)
            rectFingerFourRight?.position = CGPoint(x: rightPositionX, y: size.height - rightTop - fingerWidth * 3.5)

            [rectFingerOneRight, rectFingerTwoRight, rectFingerThreeRight].forEach { node in
                node?.isHidden = false
                node?.size = CGSize(width: guideWidth, height: fingerWidth)
            }
            rectFingerFourRight?.isHidden = false
            rectFingerFourRight?.size = CGSize(width: guideWidth, height: fingerWidth * 2)
        } else {
            [rectFingerOneRight, rectFingerTwoRight, rectFingerThreeRight, rectFingerFourRight].forEach({$0?.isHidden = true })
        }
        
    }
    
    func createGradientRect(width: CGFloat, height: CGFloat) -> SKSpriteNode {
        let topColor = CIColor(red: 248/255, green: 182/255, blue: 250/255, alpha: 0.15)
        let bottomColor = CIColor(red: 248/255, green: 182/255, blue: 250/255, alpha: 0.01)
        let tx = SKTexture(verticalGradientofSize: CGSize(width: width, height: height), topColor: topColor, bottomColor: bottomColor)
        return SKSpriteNode.init(texture: tx)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = self.view else { return }
        print("Touches Began")
        let noPatterenPlayedPreviously = left.count == 0
        left.removeAll()
        right.removeAll()
        
        let allTouches = event?.touches(for: view)
        var index = 0
        for touch in allTouches! {
            let position = touch.location(in: self.view)
            guard let width = self.view?.bounds.width else { return }
            if position.x < width / 2 {
                left.append(touch)
            } else {
                right.append(touch)
            }
            index += 1
        }
        isTouchesEnded = false
        isInvalidPattern = false
        self.debounce(action: #selector(handleTouches(args:)), delay: noPatterenPlayedPreviously ? 0.015 : 0.05)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches ended")
        left.removeAll()
        right.removeAll()
        guard let view = self.view else { return }
        let allTouches = event!.touches(for: view)
        let allTouchesRemoved = allTouches?.count ?? 0 == 0
        
        var touchesMinY = Int.max
        var removedTouchMinY = Int.max
        let width = view.bounds.width
        
        for touch in allTouches! {
            let position = touch.location(in: view)
            
            if touches.contains(touch) {
                let position = touch.location(in: view)
                print("Removed touch position \(position.x) \(position.y)")
                if position.x < width / 2 {
                    removedTouchMinY = min(removedTouchMinY, Int(position.y))
                }
                continue
            }
            print("touchesEnded(): touch x pos = \(position.x)")
            if position.x < width / 2 {
                left.append(touch)
                touchesMinY = min(touchesMinY, Int(position.y))
            } else {
                right.append(touch)
            }
        }
        isTouchesEnded = true
        print("removedTouchMinY = \(removedTouchMinY), touchesMinY = \(touchesMinY)")
        if removedTouchMinY < touchesMinY {
            print("Invalid pattern found (accidentally released topmost right touch")
            isInvalidPattern = true
        }
        debounce(action: #selector(handleTouches(args:)), delay: allTouchesRemoved ? 0 : 0.05)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isInvalidPattern ?? false {
            return
        }
        left.removeAll()
        right.removeAll()
        guard let view = self.view else { return }
        let allTouches = event?.touches(for: view)
        var index = 0

        for touch in allTouches! {
            let position = touch.location(in: self.view)
            let width = self.view?.bounds.width ?? 0
            if position.x < width / 2 {
                left.append(touch)
            } else {
                right.append(touch)
            }
            index += 1
        }
        self.sortTouches(&left)
        self.sortTouches(&right)
        theme?.leftHandMoved(touches: left)
        theme?.rightHandMoved(touches: right)
        self.drawPatternGuides()

        let topRight = left.first
        lastRightTop = topRight?.location(in: view).y

        if right.count > 0, left.count > 0 {
            handleLeftYCtrl(touch: right.first)
            self.handleLeftXCtrl(touch: right.first, isMoved: true)
            self.handleRightYCtrl(touch: left.first)
            self.handleRightXCtrl(touch: left.first)
        }

    }
    @objc func handleTouches(args: [Any]) {
        
        hideMenu()
        
        self.sortTouches(&left)
        self.sortTouches(&right)
        self.drawPatternGuides()
        
        let rightPattern = self.getPattern(&right, withAux: true)
        let leftPattern = self.getPattern(&left, withAux: true )
    
        var baseNote: Int = 0
        if leftPattern == 8 {
            // calibrate
            debounce(action: #selector(calibrate), delay: 1.0)
        } else {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(calibrate), object: nil)
        }
        
        if isInvalidPattern ?? false || rightPattern == 0 {
            // stop audio and clear all visual indication
            noteOff(playedNote, isOtherNotePlaying: false)
            self.theme?.drawLeftHandTouches(pattern: 0, touches: left)
            self.theme?.drawRightHandTouches(pattern: 0, touches: right)
            
            self.debounce(action: #selector(showMenu), delay: 1)
            return
        } else {
            theme?.drawRightHandTouches(pattern: rightPattern, touches: right)
            baseNote = 48 + 6 * (rightPattern - 1)
        }
        
        print("handleTouches() - left touches:")
        for touch in left {
            print("handleTouches(): touch y position = \(touch.location(in: view).y)")
        }
        
        if (!left.isEmpty) {
            print("handleTouches(): first left y = \(left.first!.location(in: view).y)")
        }
        
        let leftTop = right.first
        let rightTop = left.first
        
        if isTouchesEnded ?? false {
            
        } else  {
            isLeftMuted = false
            isRightMuted = false
        }
        
        lastLeftTop = leftTop?.location(in: view).y
        lastRightTop = rightTop?.location(in: view).y
        print("handleTouches(): left count = \(left.count), right count = \(right.count)")
        print("handleTouches(): left pattern = \(leftPattern), right pattern = \(rightPattern)")
        if !(isTouchesEnded ?? false) && rightPattern != 0 && leftPattern != 0 {
            self.handleLeftYCtrl(touch: right.first)
            self.handleLeftXCtrl(touch: right.first, isMoved: false)
            self.handleRightYCtrl(touch: left.first)
            self.handleRightXCtrl(touch: left.first)
        }
        
        switch leftPattern {
        case 0:
            self.noteOff(playedNote, isOtherNotePlaying: false)
            theme?.drawLeftHandTouches(pattern: 0, touches: left)
            theme?.drawRightHandTouches(pattern: 0, touches: right)
        case 1:
            prevNote = playedNote
            self.noteOn(baseNote, velocity: self.velocity(touch: left.first))
            if prevNote != playedNote {
                self.noteOff(prevNote, isOtherNotePlaying: true)
            }
        case 2, 3, 4, 5, 6:
            prevNote = playedNote
            self.noteOn(baseNote + (leftPattern - 1) , velocity: self.velocity(touch: left.first))
            if prevNote != playedNote {
                self.noteOff(prevNote, isOtherNotePlaying: true)
            }
            break
        default:
           break
        }
        theme?.drawLeftHandTouches(pattern: leftPattern, touches: left)
    }
    
    func noteOn(_ noteNumber: Int, velocity: Int) {
        midiConnector.sendNote(on: noteNumber, inChannel: 1, withVelocity: velocity)
        playedNote = noteNumber
        self.sendMidiToPDwithNoteNumner(noteNumber, andVelocity: velocity)
        if Settings.isSynthEnabled.value {
            SynthManager.instance.noteOn(noteNumber)
        }
    }
    
    func sendMidiToPDwithNoteNumner(_ noteNumber: Int, andVelocity velocity: Int) {
        if PDEnabled ?? false {
            print("PD Enabled")
            print("Send note number \(noteNumber) and velocity \(velocity)")
        } else {
            print("PD Disabled")
        }
    }
    
    func noteOff(_ noteNumber: Int?, isOtherNotePlaying: Bool) {
        guard let noteNumber = noteNumber else { return }
        midiConnector.sendNoteOff(noteNumber, inChannel: 1, withVelocity: 120)
        if !isOtherNotePlaying {
            self.sendMidiToPDwithNoteNumner(noteNumber, andVelocity: 0)
        }
        if Settings.isSynthEnabled.value {
            SynthManager.instance.noteOff(noteNumber)
        }
    }
    
    func getPattern(_ touches: inout [UITouch], withAux: Bool) -> Int {
        print("IN: getPattern()")
        for touch in touches {
            let location = touch.location(in: view).y
            print("getPattern(): Touch location \(location)")
        }
        if touches.count == 0 {
            return 0
        }
        if touches.count == 1 {
            return 1
        } else if touches.count == 2 && distance(first: touches[0], second: touches[1]) < fingerWidth * 1.5 {
            return 2
        } else if touches.count == 2 && distance(first: touches[0], second: touches[1]) < fingerWidth * 2.5 {
            return 4
        } else if touches.count == 3 && distance(first: touches[0], second: touches[1]) < fingerWidth * 1.5 && distance(first: touches[0], second: touches[2]) < fingerWidth * 2.5 {
            return 3
        } else if touches.count == 3 && distance(first: touches[0], second: touches[1]) < fingerWidth * 2.5 && distance(first: touches[0], second: touches[1]) > fingerWidth * 1.5 && distance(first: touches[1], second: touches[2]) < fingerWidth * 2.5 {
            return 5
        } else if touches.count == 2 && distance(first: touches[0], second: touches[1]) < fingerWidth * 4.5 {
            return 6
        } else if touches.count == 3 && distance(first: touches[0], second: touches[1]) < fingerWidth * 1.5 && distance(first: touches[1], second: touches[2]) < fingerWidth * 2.5 {
            return 7
        } else if touches.count == 4 {
            return 8
        }
        return -1
    }
    
//    func sortTouches(_ touches: [UITouch]?) {
//        guard let touches = touches else { return }
//        touches.
//    }
    
    func sortTouches(_ touches: inout [UITouch]) {
        // < accending
        // > decending
        
        touches.sort(by: { a, b in
            let firstLoc = a.location(in: view)
            let secondLoc = b.location(in: view)
            return firstLoc.y < secondLoc.y
        })
    }
    
    @objc func showMenu() {
        NotificationCenter.default.post(name: .showMenu, object: nil)
    }
    
    @objc func hideMenu() {
        NotificationCenter.default.post(name: .hideMenu, object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showMenu), object: nil)
        NotificationCenter.default.post(name: .hideMenu, object: nil)
    }
    
    
    @objc func calibrate() {
        let firstDistance = self.distance(first: left.first, second: left[1])
        let secondDistance = self.distance(first: left[1], second: left[2])
        print("FirstDiscance \(firstDistance), Second: \(secondDistance)")
        fingerWidth = (firstDistance + secondDistance) / 2
        SettingsManager.fingerWidth = max(firstDistance, secondDistance) // quick calibration fix but might not be accurate
        print("Calibrate --> new finger width is \(fingerWidth ?? 0)")
        self.drawPatternGuides()
        
    }
    
    func debounce(action: Selector, delay: TimeInterval) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: action, object: previousArgs)
        self.perform(action, with: nil, afterDelay: delay)
    }
    
    func distance(first: UITouch?, second: UITouch?) -> CGFloat {
        guard let first = first, let second = second else { return 0 }
        return abs(first.location(in: self.view).y - second.location(in: self.view).y)
    }
    
    //MARK: - Operator handling
    func handleLeftYCtrl(touch: UITouch?) {
        guard let touch = touch else { return }
        if !SettingsManager.leftYCtrlEnabled || isLeftMuted ?? false {
            return
        }
        let location = touch.location(in: self.view)
        let height = self.view?.bounds.height ?? 0
        let maxPercent = max(0, location.y - height / 4) * 100 / (height / 3)
        let percent = min(maxPercent, 100)
        let currentVal = floor(percent * 127 / 100)
        self.theme?.verticalLeftChanged(Int(currentVal))
        if Int(currentVal) != leftYCurrent {
            leftYCurrent = Int(currentVal)
            midiConnector.sendControllerChange(SettingsManager.leftYCtrlValue, value: Int(currentVal), inChannel: 1)
            if Settings.isSynthEnabled.value {
                SynthManager.instance.resonance(Int(currentVal))
            }
        }
    }
    
    func handleLeftXCtrl(touch: UITouch?, isMoved: Bool) {
        guard let touch = touch else { return }
        if !SettingsManager.leftXCtrlEnabled { return }
        let location = touch.location(in: self.view)
        let width = self.view?.bounds.width ?? 0
        let minPercent = min(100, (width - location.x) * 100 / (width / 2))
        let percent = max(0, minPercent)
        let currentVal = Int(floor(percent * 127 / 100))
        if currentVal != leftXCurrent {
            leftXCurrent = currentVal
            midiConnector.sendControllerChange(SettingsManager.leftXCtrlValue, value: currentVal, inChannel: 1)
        }
    }
    
    func handleRightYCtrl(touch: UITouch?) {
        guard let touch = touch else { return }
        if SettingsManager.keySwitchEnabled {
            self.handleKeySwitch(touch: touch)
            return
        }
        
        if !SettingsManager.rightYCtrlEnabled || self.isRightMuted ?? false {
            return
        }
        let location = touch.location(in: self.view)
        let height = self.view?.bounds.height ?? 0
        print("handleTouches() - right Y Ctrl touch y value = \(location.y)")
        let maxPercent = max(0, location.y - height / 4) * 100 / (height / 3)
        let percent = min(maxPercent, 100)
        let currentVal = Int(floor(percent * 127 / 100))
        self.theme?.verticalRightChanged(currentVal)
        if Int(currentVal) != rightYCurrent {
            rightYCurrent = Int(currentVal)
            midiConnector.sendControllerChange(SettingsManager.rightYCtrlValue, value: Int(currentVal), inChannel: 1)
            if Settings.isSynthEnabled.value {
                SynthManager.instance.filterCutoff(currentVal)
            }
        }
    }
    
    func handleRightXCtrl(touch: UITouch?) {
        guard let touch = touch else { return }
        if SettingsManager.pitchBendEnabled {
            self.handlePitchBend(touch)
        }
        if !SettingsManager.rightXCtrlEnabled { return }
        let location = touch.location(in: self.view)
        let width = self.view?.bounds.width ?? 0
        let maxPercent = max(0, location.x * 100 / (width / 2))
        let percent = min(100, maxPercent)
        let currentVal = Int(floor(percent * 127 / 100))
        if currentVal != rightXCurrent {
            rightXCurrent = currentVal
            midiConnector.sendControllerChange(SettingsManager.rightXCtrlValue, value: currentVal, inChannel: 1)
        }
    }
    
    
    func handleKeySwitch(touch: UITouch?) {
        guard let touch = touch else { return }
    }
    
    func handlePitchBend(_ touch: UITouch?) {
        guard let touch = touch else { return }
    }
    
    func velocity(touch: UITouch?) -> Int {
        guard let touch = touch, let width = view?.bounds.width else { return 100 }
        if SettingsManager.velocityEnabled {
            let location = touch.location(in: self.view)
            let percent = Int(location.x * 100 / (width / 2))
            let velocity: Int = Int(floor(Double(percent * 127 / 100)) + 20)
            return velocity
        }
        return 100
    }
}


extension UIColor {
    convenience init(withRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    class var rightPitchbendArea: UIColor {
        return UIColor(withRed: 248, green: 182, blue: 255, alpha: 0.2)
    }
    class var leftPitchBandArea: UIColor {
        return UIColor(withRed: 248, green: 182, blue: 250, alpha: 0.0)
    }
    
    
}
