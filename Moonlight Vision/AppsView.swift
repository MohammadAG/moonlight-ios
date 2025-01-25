//
//  AppView.swift
//  Moonlight Vision
//
//  Created by Alex Haugland on 1/27/24.
//  Copyright © 2024 Moonlight Game Streaming Project. All rights reserved.
//

import Foundation
import SwiftUI

struct AppsView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    public var host: TemporaryHost
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150 * 1.5))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumn, spacing: 40) {
                ForEach(host.appList.sorted(by: { $0.name ?? "" < $1.name ?? "" }), id: \.id) { app in
                    AppButtonView(host: host, app: app) {
                        viewModel.stream(app: app)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(host.name)
        .task {
            viewModel.refreshAppsFor(host: host)
        }.refreshable() {
            viewModel.refreshAppsFor(host: host)
        }
    }
}

struct AppButtonView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    var host: TemporaryHost
    var app: TemporaryApp
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Group {
                    if let image = viewModel.appImage[app] {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Text(app.name ?? "Unknown")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .padding()
                    }
                }
            }
        }
        .badge(Text(app.id == host.currentGame ? "Running" : ""))
        .contextMenu {
            if app.id == host.currentGame {
                Button {
                    let httpManager = HttpManager(host: app.host())
                    let httpResponse = HttpResponse()
                    let quitRequest = HttpRequest(for: httpResponse, with: httpManager?.newQuitAppRequest())
                    Task {
                        httpManager?.executeRequestSynchronously(quitRequest)
                        // lol no error handling...
                    }
                } label: {
                    Label("Stop", systemImage: "stop.circle")
                }
            }
        }
        .buttonBorderShape(.roundedRectangle(radius: 20))
        .clipShape(.rect(cornerRadius: 20))
        .frame(width: 150 * 1.5, height: 200 * 1.5)
        .clipped()
    }
}
