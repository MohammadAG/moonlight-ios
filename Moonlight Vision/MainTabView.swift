//
//  MainTabView.swift
//  Moonlight
//
//  Created by Mohammad Abu-Garbeyyeh on 25/01/2025.
//  Copyright © 2025 Moonlight Game Streaming Project. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    @State private var selectedHost: TemporaryHost?
    @State private var addingHost = false
    @State private var newHostIp = ""
    
    var body: some View {
        TabView {
            NavigationSplitView {
                List(viewModel.hosts, selection: $selectedHost) { host in
                    NavigationLink(value: host) {
                        HostRow(host: host, selectedHost: $selectedHost)
                    }
                }
                .onChange(of: viewModel.hosts) {
                    // If the hosts list changes and no host is selected,
                    // try to select the first paired host automatically.
                    if selectedHost == nil,
                       let firstHost = viewModel.hosts.first(where: { $0.pairState == .paired })
                    {
                        selectedHost = firstHost
                    }
                }
                .navigationTitle("Computers")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add Server", systemImage: "plus") {
                            addingHost = true
                        }.alert(
                            "Enter server",
                            isPresented: $addingHost
                        ) {
                            TextField("IP or Host", text: $newHostIp)
                            Button("Add") {
                                addingHost = false
                                viewModel.manuallyDiscoverHost(hostOrIp: newHostIp)
                            }
                            Button("Cancel", role: .cancel) {
                                addingHost = false
                            }
                        }.alert(
                            "Unable to add host",
                            isPresented: $viewModel.errorAddingHost
                        ) {
                            Button("Ok", role: .cancel) {
                                viewModel.errorAddingHost = true
                            }
                        } message: {
                            Text(viewModel.addHostErrorMessage)
                        }
                    }
                }
            } detail: {
                if let selectedHost {
                    ComputerView(host: selectedHost)
                }
            }.tabItem {
                Label("Computers", systemImage: "desktopcomputer")
            }
            .task {
                viewModel.loadSavedHosts()
            }
            .onAppear {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(viewModel.beginRefresh),
                    name: UIApplication.didBecomeActiveNotification,
                    object: nil
                )
                viewModel.beginRefresh()
            }.onDisappear {
                viewModel.stopRefresh()
                NotificationCenter.default.removeObserver(self)
            }
        
            SettingsView(settings: $viewModel.streamSettings).tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
