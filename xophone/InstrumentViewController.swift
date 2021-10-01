//
//  InstrumentViewController.swift
//  monoleap
//
//  Created by Omer Elimelech on 16/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

@objc class InstrumentViewController: UIViewController {
    
    var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "showSettings.png"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        let skView: SKView = SKView(frame: self.view.frame)
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        self.view.isMultipleTouchEnabled = true
        skView.isMultipleTouchEnabled = true
        view.addSubview(skView)
        let scene = InstrumentScene1.unarchive(fromFile: "InstrumentScene")
        scene?.anchorPoint = CGPoint(x: 0, y: 0)
        scene?.scaleMode = .resizeFill
        

        skView.presentScene(scene)
        
        initMenuButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSettings), name: .showSettings, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideMenu), name: .hideMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showMenu), name: .showMenu, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func initMenuButton() {
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        settingsButton.frame = CGRect(x: view.frame.width - 138, y: view.frame.height - 138, width: 128, height: 128)
        self.view.addSubview(settingsButton)
    }
    
    @objc func orientationChanged(_ notification: Notification) {
        settingsButton.frame = CGRect(x: view.frame.width - 138, y: view.frame.height - 138, width: 128, height: 128)
    }
    
    @objc func showSettings() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideMenu() {
        UIView.animate(withDuration: 0.25) {
            self.settingsButton.alpha = 0
        } completion: { finished in
            self.settingsButton.isHidden = true
        }
    }
    
    @objc func showMenu() {
        settingsButton.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.settingsButton.alpha = 1
        }
    }
    
    
}

extension Notification.Name {
    static let showSettings = Notification.Name("showSettings")
    static let hideMenu = Notification.Name("hideMenu")
    static let showMenu = Notification.Name("showMenu")
}

extension SKScene {
    //  Converted to Swift 5.5 by Swiftify v5.5.22923 - https://swiftify.com/
    class func unarchive(fromFile file: String?) -> SKScene? {
        let nodePath = Bundle.main.path(forResource: file, ofType: "sks")
        var data: Data? = nil
        do {
            data = try NSData(contentsOfFile: nodePath ?? "", options: .mappedIfSafe) as Data?
        } catch {
        }
        var arch: NSKeyedUnarchiver? = nil
        if let data = data {
            arch = NSKeyedUnarchiver(forReadingWith: data)
        }
        arch?.setClass(self, forClassName: "SKScene")
        let scene = arch?.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? SKScene
        arch?.finishDecoding()
        return scene
    }
    
    
}
