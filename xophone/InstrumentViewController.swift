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
        button.setImage(UIImage(named: "settings_new"), for: .normal)
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
        let scene = InstrumentScene()
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .resizeFill
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
        updateSettingsButton()
        self.view.addSubview(settingsButton)
    }
    
    @objc func orientationChanged(_ notification: Notification) {
        updateSettingsButton()
    }
    
    func updateSettingsButton() {
        settingsButton.frame = CGRect(x: view.frame.width - 170, y: view.frame.height - 170, width: 140, height: 142)
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
