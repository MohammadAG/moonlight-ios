//

import SwiftUI
import GameController

struct MainContentView: View {
    @EnvironmentObject private var viewModel: MainViewModel
    
    var body: some View {
        if viewModel.activelyStreaming {
            StreamContainerView()
        } else {
            MainTabView()
        }
    }
}

#Preview {
    MainContentView().environmentObject(MainViewModel())
}
