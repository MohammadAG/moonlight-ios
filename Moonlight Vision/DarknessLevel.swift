//
//  DarknessLevel.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 25/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import SwiftUI

enum DarknessLevel: Hashable {
    case undimmed
    case semi
    case dimmed
    case ultraDimmed
    
    var effect: SurroundingsEffect? {
        switch self {
        case .undimmed:
            return nil
        case .semi:
            return .semiDark
        case .dimmed:
            return .dark
        case .ultraDimmed:
            return .ultraDark
        }
    }
}
