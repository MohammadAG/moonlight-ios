//
//  StreamContainerView.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 25/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import SwiftUI

struct StreamContainerView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    @StateObject var toolbarViewModel = ToolbarViewModel()
    
    @State private var showExtraButtons = false
    
    @State private var darknessLevel = DarknessLevel.dimmed
    
    var body: some View {
        ZStack {
            StreamView(streamConfig: $viewModel.currentStreamConfig)
                .handlesGameControllerEvents(matching: .gamepad)
                .environmentObject(toolbarViewModel)
        }
        .onAppear {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let geometryRequest = UIWindowScene.GeometryPreferences.Vision(resizingRestrictions: .uniform)
            windowScene.requestGeometryUpdate(geometryRequest)
        }
        .onDisappear {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let geometryRequest = UIWindowScene.GeometryPreferences.Vision(resizingRestrictions: .freeform)
            windowScene.requestGeometryUpdate(geometryRequest)
        }
        .toolbar {}
        .ornament(attachmentAnchor: .scene(.topLeading), contentAlignment: .bottomLeading) {
            HStack {
                Picker("Darkness", selection: $darknessLevel) {
                    Label("Bright", systemImage: "sun.max")
                        .tag(DarknessLevel.undimmed)
                    Label("Semi-dimmed", systemImage: "moonphase.waxing.crescent.inverse")
                        .tag(DarknessLevel.semi)
                    Label("Dimmed", systemImage: "moonphase.waning.crescent")
                        .tag(DarknessLevel.dimmed)
                    Label("Ultra-dimmed", systemImage: "moonphase.full.moon.inverse")
                        .tag(DarknessLevel.ultraDimmed)
                }
                
                
                
                Button("Show extra buttons", systemImage: showExtraButtons ? "ellipsis.rectangle.fill" : "ellipsis.rectangle") {
                    withAnimation {
                        showExtraButtons.toggle()
                    }
                }
            }
            .labelStyle(.iconOnly)
            .padding()
        }
        .ornament(attachmentAnchor: .scene(.topTrailing), contentAlignment: .bottomTrailing) {
            HStack {
                Button("Close", systemImage: "xmark") {
                    viewModel.activelyStreaming = false
                }
            }
            .labelStyle(.iconOnly)
            .padding()
        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            if showExtraButtons {
                VStack {
                    Spacer(minLength: 100)
                    
                    ToolbarView()
                        .environmentObject(toolbarViewModel)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 30.0))
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 30.0))
        .preferredSurroundingsEffect(darknessLevel.effect)
    }
}
