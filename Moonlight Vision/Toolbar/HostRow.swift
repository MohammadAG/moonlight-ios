//
//  HostRow.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 25/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import SwiftUI

struct HostRow: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    let host: TemporaryHost
    @Binding var selectedHost: TemporaryHost?
    
    @State private var isDeletingHost = false
    @State private var hostToDelete: TemporaryHost?
    
    var body: some View {
        VStack {
            Label(host.name,
                  systemImage: host.pairState == .paired ?
                      "desktopcomputer" : "lock.desktopcomputer")
                .foregroundColor(.primary)
        }
        .contextMenu {
            Button {
                viewModel.wakeHost(host)
            } label: {
                Label("Wake PC", systemImage: "sun.horizon")
            }
            Button(role: .destructive) {
                isDeletingHost = true
                hostToDelete = host
            } label: {
                Label("Delete PC…", systemImage: "trash")
            }
        }
        .alert("Really delete?", isPresented: $isDeletingHost) {
            Button("Yes, delete it", role: .destructive) {
                if let hostToDelete {
                    viewModel.removeHost(hostToDelete)
                    selectedHost = nil
                }
            }
            Button("Cancel", role: .cancel) {
                isDeletingHost = false
                hostToDelete = nil
            }
        }
    }
}
