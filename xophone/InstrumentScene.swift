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

class InstrumentScene: SKScene {
    
    var playedNote: Int?
    var prevNote: Int?
    
    var previousArgs: Array<Any>?
    
    var rightHandTouches = [UITouch]()
    var leftHandTouches = [UITouch]()
    
    var fingerWidth: CGFloat!
    
    var theme: Theme?

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
    
    var midiChannel = Settings.midiChannel.value - 1
    
    var leftYCurrent, leftXCurrent, rightYCurrent, rightXCurrent: Int?
    
    var isTouchesEnded, isInvalidPattern: Bool?
    
    var synthManager: SynthManager?
    
    let fingeringScheme = FingeringSchemeManager.instance.getCurrentScheme()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = SKColor(MonoleapAssets.darkBackground)
        
        self.midiConnector = MIDIConnector.instance
        self.rightHandTouches = [UITouch]()
        self.leftHandTouches = [UITouch]()
    
        theme = ThemeManager.instance.createCurrentTheme()
        theme?.apply(to: self)
        
        self.fingerWidth = Settings.fingerWidth.value
        synthManager = SynthManager()
    }
    
    func drawPatternGuides() {
        let guideWidth: CGFloat = self.size.width / 2 - 20
        if rightHandTouches.count > 0 {
            let topRight = rightHandTouches.first
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

        if leftHandTouches.count > 0 {
            let touch = leftHandTouches.first
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
    
    private func hidePatternGuides() {
        [rectFingerOneLeft, rectFingerTwoLeft, rectFingerThreeLeft, rectFingerFourLeft].forEach({$0?.isHidden = true})
        [rectFingerOneRight, rectFingerTwoRight, rectFingerThreeRight, rectFingerFourRight].forEach({$0?.isHidden = true })
    }
    
    func createGradientRect(width: CGFloat, height: CGFloat) -> SKSpriteNode {
        let topColor = CIColor(red: 248/255, green: 182/255, blue: 250/255, alpha: 0.15)
        let bottomColor = CIColor(red: 248/255, green: 182/255, blue: 250/255, alpha: 0.01)
        let tx = SKTexture(verticalGradientofSize: CGSize(width: width, height: height), topColor: topColor, bottomColor: bottomColor)
        return SKSpriteNode.init(texture: tx)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = self.view else { return }
        
        let noPatterenPlayedPreviously = rightHandTouches.count == 0
        rightHandTouches.removeAll()
        leftHandTouches.removeAll()
        
        let allTouches = event?.touches(for: view)
        var index = 0
        for touch in allTouches! {
            let position = touch.location(in: self.view)
            guard let width = self.view?.bounds.width else { return }
            if position.x < width / 2 {
                rightHandTouches.append(touch)
            } else {
                leftHandTouches.append(touch)
            }
            index += 1
        }
        isTouchesEnded = false
        isInvalidPattern = false
        
        self.debounce(action: #selector(handleTouches(args:)), delay: noPatterenPlayedPreviously ? 0.015 : 0.05)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rightHandTouches.removeAll()
        leftHandTouches.removeAll()
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
//                print("Removed touch position \(position.x) \(position.y)")
                if position.x < width / 2 {
                    removedTouchMinY = min(removedTouchMinY, Int(position.y))
                }
                continue
            }
//            print("touchesEnded(): touch x pos = \(position.x)")
            if position.x < width / 2 {
                rightHandTouches.append(touch)
                touchesMinY = min(touchesMinY, Int(position.y))
            } else {
                leftHandTouches.append(touch)
            }
        }
        isTouchesEnded = true
//        print("removedTouchMinY = \(removedTouchMinY), touchesMinY = \(touchesMinY)")
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
        rightHandTouches.removeAll()
        leftHandTouches.removeAll()
        guard let view = self.view else { return }
        let allTouches = event?.touches(for: view)
        var index = 0

        for touch in allTouches! {
            let position = touch.location(in: self.view)
            let width = self.view?.bounds.width ?? 0
            if position.x < width / 2 {
                rightHandTouches.append(touch)
            } else {
                leftHandTouches.append(touch)
            }
            index += 1
        }
        self.sortTouches(&rightHandTouches)
        self.sortTouches(&leftHandTouches)
        theme?.rightHandMoved(touches: rightHandTouches, pattern: getPattern(&rightHandTouches, withAux: true))
        theme?.leftHandMoved(touches: leftHandTouches, pattern: getPattern(&leftHandTouches, withAux: true))
        if (Settings.showPatternGuides.value) {
            self.drawPatternGuides()
        }

        let topRight = rightHandTouches.first
        lastRightTop = topRight?.location(in: view).y

        if leftHandTouches.count > 0, rightHandTouches.count > 0 {
            handleLeftYCtrl(touch: leftHandTouches.first)
            self.handleLeftXCtrl(touch: leftHandTouches.first, isMoved: true)
            self.handleRightYCtrl(touch: rightHandTouches.first)
            self.handleRightXCtrl(touch: rightHandTouches.first)
        }

    }
    
    @objc func handleTouches(args: [Any]) {
        
        hideMenu()
        
        self.sortTouches(&rightHandTouches)
        self.sortTouches(&leftHandTouches)
        
        let leftPattern = self.getPattern(&leftHandTouches, withAux: true)
        let rightPattern = self.getPattern(&rightHandTouches, withAux: true )
    
        let leadingPattern = Settings.isRightHanded.value ? rightPattern : leftPattern
        let followingPattern = Settings.isRightHanded.value ? leftPattern : rightPattern
        
        if (Settings.showPatternGuides.value) {
            self.drawPatternGuides()
        } else {
            self.hidePatternGuides()
        }
        
        var baseNote: Int = 0
        
        if Settings.calibrationEnabled.value {
            if leadingPattern == 8 {
                // calibrate
                debounce(action: #selector(calibrate), delay: 1.0)
            } else {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(calibrate), object: nil)
            }
        }
        
        if isInvalidPattern ?? false || followingPattern == 0 {
            // stop audio and clear all visual indication
            noteOff(playedNote, isOtherNotePlaying: false)
            self.theme?.drawRightHandTouches(pattern: 0, touches: rightHandTouches)
            self.theme?.drawLeftHandTouches(pattern: 0, touches: leftHandTouches)
            
            self.debounce(action: #selector(showMenu), delay: 1)
            return
        }
        
        let leftTop = leftHandTouches.first
        let rightTop = rightHandTouches.first
        
        lastLeftTop = leftTop?.location(in: view).y
        lastRightTop = rightTop?.location(in: view).y
        
        if !(isTouchesEnded ?? false) && leftPattern != 0 && rightPattern != 0 {
            self.handleLeftYCtrl(touch: leftHandTouches.first)
            self.handleLeftXCtrl(touch: leftHandTouches.first, isMoved: false)
            self.handleRightYCtrl(touch: rightHandTouches.first)
            self.handleRightXCtrl(touch: rightHandTouches.first)
        }
        
        theme?.drawLeftHandTouches(pattern: leftPattern, touches: leftHandTouches)
        theme?.drawRightHandTouches(pattern: rightPattern, touches: rightHandTouches)
        
        if (leadingPattern > 0) {
            if var noteToPlay = fingeringScheme.getNoteNumber(leadingPattern: leadingPattern, followingPattern: followingPattern) {
                noteToPlay += Settings.transpose.value
                if !ScaleMatcher.doesNoteMatchCurrentScale(noteToPlay) {
                    return;
                }
                prevNote = playedNote
                self.noteOn(noteToPlay , velocity: 100)
                if prevNote != playedNote {
                    self.noteOff(prevNote, isOtherNotePlaying: true)
                }
            }
        } else {
            self.noteOff(playedNote, isOtherNotePlaying: false)
        }
        
    }
    
    func noteOn(_ noteNumber: Int, velocity: Int) {
        if (Settings.isMidiEnabled.value) {
            midiConnector.sendNote(on: noteNumber, inChannel: midiChannel, withVelocity: velocity)
        }
        playedNote = noteNumber
        
        if Settings.isSynthEnabled.value {
            synthManager?.noteOn(noteNumber)
        }
    }
    
    func noteOff(_ noteNumber: Int?, isOtherNotePlaying: Bool) {
        guard let noteNumber = noteNumber else { return }
        if Settings.isMidiEnabled.value {
            midiConnector.sendNoteOff(noteNumber, inChannel: midiChannel, withVelocity: 120)
        }
        if Settings.isSynthEnabled.value {
            synthManager?.noteOff(noteNumber)
        }
    }
    
    func getPattern(_ touches: inout [UITouch], withAux: Bool) -> Int {
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
        } else if touches.count == 2 && distance(first: touches[0], second: touches[1]) > fingerWidth * 2.5 {
            return 6
        } else if touches.count == 3 && distance(first: touches[0], second: touches[1]) < fingerWidth * 1.5 && distance(first: touches[1], second: touches[2]) > fingerWidth * 1.5 {
            return 7
        } else if touches.count == 4 {
            return 8
        }
        return 0
    }
    
    func sortTouches(_ touches: inout [UITouch]) {
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
        let touches = Settings.isRightHanded.value ? rightHandTouches : leftHandTouches
        if touches.count < 4 {
            return
        }
        let firstDistance = self.distance(first: touches.first, second: touches[1])
        let secondDistance = self.distance(first: touches[1], second: touches[2])
        
        fingerWidth = max(firstDistance, secondDistance)
        Settings.fingerWidth.value =  fingerWidth
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
        if !Settings.leftYCtrlEnabled.value {
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
            if Settings.isMidiEnabled.value {
                midiConnector.sendControllerChange(Settings.leftYCtrlValue.value, value: Int(currentVal), inChannel: midiChannel)
            }
            if Settings.isSynthEnabled.value {
                if Settings.isRightHanded.value {
                    synthManager?.resonance(Int(currentVal))
                } else {
                    synthManager?.filterCutoff(Int(currentVal))
                }
            }
        }
    }
    
    func handleLeftXCtrl(touch: UITouch?, isMoved: Bool) {
        guard let touch = touch else { return }
        if !Settings.leftXCtrlEnabled.value { return }
        let location = touch.location(in: self.view)
        let width = self.view?.bounds.width ?? 0
        let xPosition = width - min(width, location.x + width / 4)
        let minPercent = min(100, xPosition * 100 / (width / 4))
        let percent = max(0, minPercent)
        let currentVal = Int(floor(percent * 127 / 100))
        if currentVal != leftXCurrent {
            leftXCurrent = currentVal
            if Settings.isMidiEnabled.value {
                midiConnector.sendControllerChange(Settings.leftXCtrlValue.value, value: currentVal, inChannel: midiChannel)
            }
        }
    }
    
    func handleRightYCtrl(touch: UITouch?) {
        guard let touch = touch else { return }
        if !Settings.rightYCtrlEnabled.value {
            return
        }
        let location = touch.location(in: self.view)
        let height = self.view?.bounds.height ?? 0
        
        let maxPercent = max(0, location.y - height / 4) * 100 / (height / 3)
        let percent = min(maxPercent, 100)
        let currentVal = Int(floor(percent * 127 / 100))
        self.theme?.verticalRightChanged(currentVal)
        if Int(currentVal) != rightYCurrent {
            rightYCurrent = Int(currentVal)
            if Settings.isMidiEnabled.value {
                midiConnector.sendControllerChange(Settings.rightYCtrlValue.value, value: Int(currentVal), inChannel: midiChannel)
            }
            if Settings.isSynthEnabled.value {
                if Settings.isRightHanded.value {
                    synthManager?.filterCutoff(currentVal)
                } else {
                    synthManager?.resonance(currentVal)
                }
            }
        }
    }
    
    func handleRightXCtrl(touch: UITouch?) {
        guard let touch = touch else { return }
        
        if !Settings.rightXCtrlEnabled.value {
            return
        }
        
        let location = touch.location(in: self.view)
        let width = self.view?.bounds.width ?? 0
        let xPosition = max(0, location.x - width / 4)
        let maxPercent = max(0, xPosition * 100 / (width / 4))
        let percent = min(100, maxPercent)
        let currentVal = Int(floor(percent * 127 / 100))
        if currentVal != rightXCurrent {
            rightXCurrent = currentVal
            if Settings.isMidiEnabled.value {
                midiConnector.sendControllerChange(Settings.rightXCtrlValue.value, value: currentVal, inChannel: midiChannel)
            }
        }
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
