//
//  ToolbarViewModel.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 24/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import Foundation

class ToolbarViewModel: ObservableObject {
    @Published var buttons: [ToolbarButtonItem] = []
    @Published var buttonState: [ToolbarButtonItem : Bool] = [:]
    
    @Published var queue: [QueuedButtonEvent] = []
    
    init() {
        buttons = [
            ToolbarButtonItem(icon: "WindowsIcon.png", keyCode: 0x5B, toggleable: true),
            ToolbarButtonItem(icon: "TabIcon.png", keyCode: 0x09, toggleable: false),
            ToolbarButtonItem(icon: "ShiftIcon.png", keyCode: 0xA0, toggleable: true),
            ToolbarButtonItem(icon: "EscapeIcon.png", keyCode: 0x1B, toggleable: false),
            ToolbarButtonItem(icon: "ControlIcon.png", keyCode: 0xA2, toggleable: true),
            ToolbarButtonItem(icon: "AltIcon.png", keyCode: 0xA4, toggleable: true),
            ToolbarButtonItem(icon: "DeleteIcon.png", keyCode: 0x2E, toggleable: false)
        ]
    }
}
