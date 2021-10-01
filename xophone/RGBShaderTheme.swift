//
//  WaveTheme.swift
//  monoleap
//
//  Created by Dan on 15/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

public class RGBShaderTheme : Theme {
   
    var backgroundShaderName: String
    
    var scene: SKScene?
    var shader: SKShader?
    var leftNodes: [Int:SKNode] = [:]
    var rightNodes: [Int:SKNode] = [:]
    var background: SKEmitterNode?
    var bgShader: SKShader?
    var bgBlue: SKShapeNode?
    var bgRed: SKShapeNode?
    var bgGreen: SKShapeNode?
    var green:Float = 0.0
    var red:Float = 0.0
    var rightPlaying: Bool = false
    var leftPlaying: Bool = false
    let initialBlueAlpha = CGFloat(0)
    
    @objc init(_ shader: String) {
        self.backgroundShaderName = shader
    }
    
    public func apply(to: SKScene) {
        self.scene = to
        shader = createCircleWave()
        background = SKEmitterNode(fileNamed: "MagicParticle.sks")
        background?.position = CGPoint(x: scene!.frame.midX, y: scene!.size.height/2);
        
        bgBlue = SKShapeNode(rect: CGRect(x: 0, y: 0, width: CGFloat(scene!.size.width), height: CGFloat(scene!.size.height)))
        bgShader = createBackgroundShader()
        bgBlue!.fillShader = bgShader!
        bgBlue!.strokeColor = UIColor(white: 0, alpha: 0)
        bgBlue!.fillColor = SKColor.blue
        bgBlue!.alpha = initialBlueAlpha
        scene!.addChild(bgBlue!)

        bgRed = SKShapeNode(rect: CGRect(x: 0, y: 0, width: CGFloat(scene!.size.width), height: CGFloat(scene!.size.height)))
        bgRed!.fillShader = bgShader!
        bgRed!.strokeColor = UIColor(white: 0, alpha: 0)
        bgRed!.fillColor = SKColor.red
        bgRed!.alpha = 0
        scene!.addChild(bgRed!)
        
        bgGreen = SKShapeNode(rect: CGRect(x: 0, y: 0, width: CGFloat(scene!.size.width), height: CGFloat(scene!.size.height)))
        bgGreen!.fillShader = bgShader!
        bgGreen!.strokeColor = UIColor(white: 0, alpha: 0)
        bgGreen!.fillColor = SKColor.green
        bgGreen!.alpha = 0
        scene!.addChild(bgGreen!)
    }
    
    public func drawRightHandTouches(pattern: Int, touches: [UITouch]) {
        draw(pattern: Int(pattern), touches: touches, nodes: &rightNodes);
        if (pattern == 0) {
            bgRed!.run(SKAction.fadeAlpha(to: 0.0, duration: 1))
            bgGreen!.run(SKAction.fadeAlpha(to: 0.0, duration: 1))
            bgBlue!.run(SKAction.fadeAlpha(to: initialBlueAlpha, duration: 1))
        } else {
            bgBlue!.run(SKAction.fadeAlpha(to: 1, duration: 1))
        }
    }
    
    public func rightHandMoved(touches: [UITouch]) {
        adjustPositions(nodes: &rightNodes, touches: touches)
    }
    
    public func drawLeftHandTouches(pattern: Int, touches: [UITouch]) {
        draw(pattern: Int(pattern), touches: touches, nodes: &leftNodes);
    }
    
    public func leftHandMoved(touches: [UITouch]) {
        adjustPositions(nodes: &leftNodes, touches: touches)
    }
    
    public func verticalLeftChanged(_ position: Int) {
        let alpha = max(0.1, Float(position) / 127.0)
        green = max(50, Float(position) / 127.0 * 255)
        shader?.uniformNamed("u_color")?.vectorFloat3Value = vector_float3(red, green, 120)
        bgGreen!.run(SKAction.fadeAlpha(to: CGFloat(alpha), duration: 1))
    }
    
    public func verticalRightChanged(_ position: Int) {
        let alpha = max(0.1, Float(position) / 127.0)
        red = max(50, Float(position) / 127.0 * 255)
        shader?.uniformNamed("u_color")?.vectorFloat3Value = vector_float3(red, green, 120)
        bgRed!.run(SKAction.fadeAlpha(to: CGFloat(alpha), duration: 1))
    }
    
    func draw(pattern: Int, touches: [UITouch], nodes: inout [Int:SKNode]) {
        switch (pattern) {
            case 0:
                hideNode(index: 0, nodes: &nodes)
                hideNode(index: 1, nodes: &nodes)
                hideNode(index: 2, nodes: &nodes)
                hideNode(index: 3, nodes: &nodes)
                break
            case 1:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                hideNode(index: 1, nodes: &nodes)
                hideNode(index: 2, nodes: &nodes)
                hideNode(index: 3, nodes: &nodes)
                break
            case 2:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                drawNode(index:1, touch:touches[1], nodes: &nodes)
                hideNode(index: 2, nodes: &nodes)
                hideNode(index: 3, nodes: &nodes)
                break
            case 3:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                drawNode(index:1, touch:touches[1], nodes: &nodes)
                drawNode(index:2, touch:touches[2], nodes: &nodes)
                hideNode(index: 3, nodes: &nodes)
                break
            case 4:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                hideNode(index: 1, nodes: &nodes)
                drawNode(index:2, touch:touches[1], nodes: &nodes)
                hideNode(index: 3, nodes: &nodes)
                break
            case 5:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                hideNode(index: 1, nodes: &nodes)
                drawNode(index:2, touch:touches[1], nodes: &nodes)
                drawNode(index:3, touch:touches[2], nodes: &nodes)
                break
            case 6:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                hideNode(index: 1, nodes: &nodes)
                hideNode(index: 2, nodes: &nodes)
                drawNode(index:3, touch:touches[1], nodes: &nodes)
                break
            case 7:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                drawNode(index:1, touch:touches[1], nodes: &nodes)
                hideNode(index: 2, nodes: &nodes)
                drawNode(index:3, touch:touches[2], nodes: &nodes)
                break
            case 8:
                drawNode(index:0, touch:touches[0], nodes: &nodes)
                drawNode(index:1, touch:touches[1], nodes: &nodes)
                drawNode(index:2, touch:touches[2], nodes: &nodes)
                drawNode(index:3, touch:touches[3], nodes: &nodes)
                break
        default:
            break
        }
    }
    
    func adjustPositions(nodes: inout [Int:SKNode], touches: [UITouch]) {
        if nodes.values.count == touches.count {
            let sortedKeys = nodes.keys.sorted()
            var idx = 0
            for index in sortedKeys {
                let node = nodes[index]!
                if !node.isHidden && idx < touches.count {
                    let touch = touches[idx]
                    node.position = touch.location(in: scene!)
                    idx += 1
                }
            }
        }
    }
    
    func drawNode(index: Int, touch: UITouch, nodes: inout [Int:SKNode]) {
        if let node = nodes[index] {
            node.position = touch.location(in: scene!)
        } else {
            let node = SKShapeNode(circleOfRadius: 90)
            node.position = touch.location(in: scene!)
            node.fillColor = SKColor.blue
            node.strokeColor = SKColor(white: 1, alpha:0)
            node.fillShader = shader
            
            node.alpha = 0
            node.run(SKAction.fadeIn(withDuration: 0.1))
            scene!.addChild(node)
            nodes[index] = node
        }
    }
    
    func hideNode(index: Int, nodes: inout [Int:SKNode]) {
        if let node = nodes[index] {
            let fadeOut = SKAction.fadeOut(withDuration: 0.4)
            let remove = SKAction.run({ node.removeFromParent() })
            node.run(SKAction.sequence([fadeOut, remove]))
            nodes[index] = nil
        }
    }
    
    func createCircleWave() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_brightness", float: 0.05),
            SKUniform(name: "u_strength", float: 0.4),
            SKUniform(name: "u_density", float: 80),
            SKUniform(name: "u_color", vectorFloat3: vector_float3(26, 117, 173))
        ]
        let shader =  SKShader(fileNamed: "SHKCircleWave.fsh")
        shader.uniforms = uniforms
        return shader
    }
    
    func createBackgroundShader() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_resolution", vectorFloat2: vector_float2(Float(scene!.size.width * 2), Float(scene!.size.height * 2))),
            SKUniform(name: "u_color", vectorFloat3: vector_float3(0, 0, 0.40)),
            SKUniform(name: "u_speed", float: 1),
            SKUniform(name: "u_playing", float: 0)
        ]
        let shader = SKShader(fileNamed: backgroundShaderName)
        shader.uniforms = uniforms
        return shader
    }

}
