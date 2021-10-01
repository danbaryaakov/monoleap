//
//  ThemeImpl.swift
//  monoleap
//
//  Created by Omer Elimelech on 16/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import UIKit


//@objc protocol ThemeImpl {
//    @objc func apply(to scene: InstrumentScene?)
//    @objc func remove(from scene: InstrumentScene?)
//    @objc func verticalRightChanged(_ position: Int)
//    @objc func verticalLeftChanged(_ position: Int)
//    func drawParticles(forPattern pattern: Int, touches: [UITouch]?, particles: Particle)
//    @objc func drawLeftHandTouches(_ pattern: Int, touches: [UITouch]?)
//    @objc func drawRightHandTouches(_ pattern: Int, touches: [UITouch]?)
//    @objc func leftHandMoved(_ touches: [UITouch]?)
//    @objc func rightHandMoved(_ touches: [UITouch]?)
//}

//extension ThemeImpl {
//    func apply(to scene: InstrumentScene?) { }
//    func remove(from scene: InstrumentScene?) { }
//    func verticalRightChanged(_ position: Int) { }
//    func verticalLeftChanged(_ position: Int) { }
//    func drawParticles(forPattern pattern: Int, touches: [UITouch]?, particles: inout Particle) { }
//    func drawLeftHandTouches(_ pattern: Int, touches: [UITouch]?) { }
//    func drawRightHandTouches(_ pattern: Int, touches: [UITouch]?) { }
//    func leftHandMoved(_ touches: [UITouch]?) { }
//    func rightHandMoved(_ touches: [UITouch]?) { }
//}

typealias Particle = [Int: SKEmitterNode]

@objc class BaseTheme: NSObject {
    var parent: InstrumentScene?
    var leftParticles: Particle!
    var rightParticles: Particle!
}

import SpriteKit

@objc class BasicTheme: BaseTheme {
    @objc func verticalRightChanged(_ position: Int) {
        
    }
    
    @objc func verticalLeftChanged(_ position: Int) {
        
    }
    
    @objc func leftHandMoved(_ touches: [UITouch]?) {
        self.adjustParticlePositions(leftParticles, touchs: touches)
    }
    
    @objc func rightHandMoved(_ touches: [UITouch]?) {
        self.adjustParticlePositions(rightParticles, touchs: touches)
    }
    
    @objc func apply(to scene: InstrumentScene?) {
        parent = scene
        leftParticles = Particle()
        rightParticles = Particle()
    }
    
    @objc func remove(from scene: InstrumentSceneOld?) {
        parent = nil
    }
    
    @objc func drawRightHandTouches(_ pattern: Int, touches: [UITouch]?) {
        self.drawParticles(forPattern: pattern, touches: touches, particles: &rightParticles)
    }
    
    @objc func drawLeftHandTouches(_ pattern: Int, touches: [UITouch]?) {
        self.drawParticles(forPattern: pattern, touches: touches, particles: &leftParticles)
    }
    
    func drawParticles(forPattern pattern: Int, touches: [UITouch]?, particles: inout Particle) {
        switch pattern {
        case 0:
            (0...3).forEach({hideParticle($0, particles: particles)})
        case 1:
            self.drawParicle(0, touch: touches?[0], particles: &particles, color: .blue)
            self.hideParticle(1, particles: particles)
            self.hideParticle(2, particles: particles)
            self.hideParticle(3, particles: particles)
        case 2:
            self.drawParicle(0, touch: touches?[0], particles: &particles, color: .cyan)
            self.drawParicle(1, touch: touches?[1], particles: &particles, color: .cyan)
            self.hideParticle(2, particles: particles)
            self.hideParticle(3, particles: particles)
        case 3:
            self.drawParicle(0, touch: touches?[0], particles: &particles, color: .green)
            self.drawParicle(1, touch: touches?[1], particles: &particles, color: .green)
            self.drawParicle(2, touch: touches?[2], particles: &particles, color: .green)
            self.hideParticle(3, particles: particles)
        case 4:
           // (0...3).forEach({drawParicle($0, touch: touches?[$0], particles: &particles, color: .yellow)})
            self.drawParicle(0, touch: touches?[0], particles: &particles, color: .yellow)
            self.hideParticle(1, particles: particles)
            self.hideParticle(2, particles: particles)
            self.drawParicle(3, touch: touches?[1], particles: &particles, color: .yellow)
        case 5:
            self.drawParicle(0, touch: touches?[0], particles: &particles, color: .purple)
            self.hideParticle(1, particles: particles)
            self.drawParicle(2, touch: touches?[1], particles: &particles, color: .purple)
            self.drawParicle(3, touch: touches?[2], particles: &particles, color: .purple)
        case 6:
            self.drawParicle(0, touch: touches?[0], particles: &particles, color: .red)
            self.hideParticle(1, particles: particles)
            self.hideParticle(2, particles: particles)
            self.drawParicle(3, touch: touches?[1], particles: &particles, color: .red)
        default:
            return
        }
    }
    
    @objc func hideParticle(_ touchIndex: Int, particles: Particle) {
        let particle = particles[touchIndex]
        if particle != nil {
            particle?.particleBirthRate = 0
            particle?.isHidden = true
        }
    }
    
    func drawParicle(_ touchIndex: Int, touch: UITouch?, particles: inout Particle, color: SKColor) {
        guard let parent = parent, let touch = touch else { return }
        let position = touch.location(in: parent)
        var particle = particles[touchIndex]
        if particle == nil {
            let emitterPath = Bundle.main.path(forResource: "Spark", ofType: "sks") ?? ""
            particle = try!  NSKeyedUnarchiver.unarchivedObject(ofClass: SKEmitterNode.self, from: Data(contentsOf: URL(fileURLWithPath: emitterPath)))
            particles[touchIndex] = particle
            particle?.position = position
            particle?.name = "Fire"
            particle?.targetNode = parent.scene
            particle?.isHidden = false
            guard particle != nil else { return }
            parent.addChild(particle!)
        } else {
            particle?.isHidden = false
            particle?.position = position
        }
        particle?.particleBirthRate = 600
        particle?.particleColorSequence = nil
        particle?.particleColorBlendFactor = 1.0
        particle?.alpha = 1
        particle?.particleColor = color
    }
    
    func adjustParticlePositions(_ particles: Particle, touchs: [UITouch]?) {
        let sorketKeys = Array(particles.keys).sorted()
        var idx = 0
        sorketKeys.forEach { key in
            let node = particles[key]
            if !(node?.isHidden ?? false) && idx < touchs?.count ?? 0 {
              let touch = touchs?[idx]
                let position = touch?.location(in: parent!)
                node?.position = position ?? .zero
                idx += 1
            }
        }
        
    }
}
