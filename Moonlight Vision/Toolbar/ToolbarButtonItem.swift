//
//  ToolbarButtonItem.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 24/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import Foundation

struct ToolbarButtonItem: Identifiable, Hashable {
    var id = UUID()
    
    let icon: String
    let keyCode: Int
    let toggleable: Bool
}
