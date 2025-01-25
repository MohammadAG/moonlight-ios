//

import OrderedCollections
import SwiftUI

struct ComputerView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    public var host: TemporaryHost

    var body: some View {
        VStack {
            if host.updatePending {
                ProgressView()
            } else {
                // do something if disconnected too
                switch host.pairState {
                case PairState.paired:
                    AppsView(host: host)
                case PairState.unpaired:
                    if viewModel.pairingInProgress {
                        Text("Pairing")
                            .font(.title)
                            .bold()
                            .padding()
                        
                        Spacer()
                        
                        Text("Enter the following PIN on the host machine:")
                        Text(viewModel.currentPin)
                            .monospacedDigit()
                            .font(.extraLargeTitle)
                            .bold()
                        
                        Text("If your host PC is running Sunshine, navigate to the Sunshine web UI to enter the PIN.")
                        
                        Button(role: .cancel) {
                            viewModel.endPairing()
                        } label: {
                            Text("Cancel")
                        }
                        
                        Spacer()
                    } else {
                        Image(systemName: "link")
                            .font(.extraLargeTitle)
                        Text("Pairing required")
                            .font(.title)
                            .padding(.bottom)
                        
                        Text(host.name)
                            .font(.title2)
                        Button("Start Pairing") {
                            viewModel.tryPairHost(host)
                        }
                    }
                default:
                    Text("Unknown state")
                }
            }
        }
        .task {
            await viewModel.updateHost(host: host)
        }
    }
}

#Preview("Pairing required") {
    let viewModel = MainViewModel()
    viewModel.pairingInProgress = false
    viewModel.currentPin = "1234"
    var outerHost: TemporaryHost = .init()
    outerHost.pairState = PairState.unpaired
    outerHost.name = "Server"

    return NavigationStack {
        ComputerView(host: outerHost).environmentObject(viewModel)
    }
}


#Preview("Pairing") {
    let viewModel = MainViewModel()
    viewModel.pairingInProgress = true
    viewModel.currentPin = "1234"
    var outerHost: TemporaryHost = .init()
    outerHost.pairState = PairState.unpaired

    return NavigationStack {
        ComputerView(host: outerHost).environmentObject(viewModel)
    }
}
