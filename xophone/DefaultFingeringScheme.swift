//
//  DefaultFingeringScheme.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 11/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

struct DefaultFingeringScheme : FingeringScheme {
    
    let name = "Default"
    
    func getNoteNumber(leadingPattern: Int, followingPattern: Int) -> Int? {
        if leadingPattern == 0 || followingPattern == 0 || leadingPattern > 6 {
            return nil
        }
        return 6 * (followingPattern - 1) + leadingPattern - 1
    }
    
}
