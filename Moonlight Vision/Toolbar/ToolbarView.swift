//
//  ToolbarView.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 24/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    
    var body: some View {
        HStack {
            ForEach(toolbarViewModel.buttons) { button in
                if !button.toggleable {
                    Button(action: {
                        toolbarViewModel.queue.append(QueuedButtonEvent(item: button, state: false))
                    }, label: {
                        Image(uiImage: UIImage(named: button.icon)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })
                    .toggleStyle(.button)
                } else {
                    Toggle(isOn: Binding(get: {
                        return toolbarViewModel.buttonState[button] ?? false
                    }, set: { newValue in
                        toolbarViewModel.buttonState[button] = newValue
                        toolbarViewModel.queue.append(QueuedButtonEvent(item: button, state: newValue))
                    })) {
                        if toolbarViewModel.buttonState[button] ?? false {
                            Image(uiImage: UIImage(named: button.icon)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .colorInvert()
                        } else {
                            Image(uiImage: UIImage(named: button.icon)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                    }
                    .toggleStyle(.button)
                }
            }
        }
        .labelStyle(.iconOnly)
        .padding()
    }
}

#Preview {
    ToolbarView()
}
