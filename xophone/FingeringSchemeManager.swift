//
//  FingeringSchemeManager.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 11/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

class FingeringSchemeManager {
    
    static public let instance = FingeringSchemeManager()
    
    public var allKeys: [String] = []
    var schemes: [String:FingeringScheme] = [:]
    
    private init() {
        register(DefaultFingeringScheme())
        register(JDFingeringScheme())
        register(JDV2FingeringScheme())
    }
    
    func register(_ scheme: FingeringScheme) {
        schemes[scheme.name] = scheme
        allKeys.append(scheme.name)
    }
    
    func getCurrentScheme() -> FingeringScheme {
        if !FeatureFlags.alternateFingeringsEnabled {
            return DefaultFingeringScheme()
        }
        if let scheme = schemes[Settings.fingeringScheme.value] {
            return scheme
        }
        return DefaultFingeringScheme()
    }
}
