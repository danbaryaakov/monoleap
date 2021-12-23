//
//  MainViewController.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 23/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation
import SwiftUI

class MainViewController : UIViewController {
    
    var contentView: UIHostingController<MainSettingsView>?
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(MonoleapAssets.darkBackground)
        var settingsView = MainSettingsView()
        settingsView.parent = self
        contentView = UIHostingController(rootView: settingsView)
        
        super.viewDidLoad()
        addChild(contentView!)
        
        view.addSubview(contentView!.view)
        
        setupConstraints()
    }
    
    public func replaceMainView() {
        var settingsView = MainSettingsView()
        settingsView.parent = self
        contentView!.removeFromParent()
        contentView!.view.removeFromSuperview()
        contentView = UIHostingController(rootView: settingsView)
        addChild(contentView!)
        view.addSubview(contentView!.view)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        contentView!.view.translatesAutoresizingMaskIntoConstraints = false
        contentView!.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView!.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView!.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
