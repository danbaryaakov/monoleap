//
//  FingeringScheme.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 11/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

public protocol FingeringScheme {
    
    var name: String { get }
    func getNoteNumber(leadingPattern: Int, followingPattern: Int) -> Int?
    
}

