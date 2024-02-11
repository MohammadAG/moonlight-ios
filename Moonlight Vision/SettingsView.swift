//

import SwiftUI

struct SettingsView: View {
    @Binding public var settings: TemporarySettings

    // TODO: round trip these to the raw settings values lol
    @State public var resolutionIndex: Int = 3
    
    @State public var framerateIndex: Int = 2
    
    @State public var bitrateIndex: Int = 3

    var body: some View {
        NavigationStack {
            Form {
                Picker("Resolution", selection: $resolutionIndex) {
                    Text("360p").tag(0)
                    Text("720p").tag(1)
                    Text("1080p").tag(2)
                    Text("4K").tag(3)
                }.onChange(of: resolutionIndex) {
                    updateResolution()
                }
                Picker("Framerate", selection: $framerateIndex) {
                    Text("30").tag(0)
                    Text("60").tag(1)
                    Text("90").tag(2)
                    Text("120").tag(3)
                }.onChange(of: framerateIndex) {
                    updateFramerate()
                }
                Picker("Bitrate", selection: $bitrateIndex) {
                    Text("10Mbps").tag(0)
                    Text("30Mbps").tag(1)
                    Text("120Mbps").tag(2)
                    Text("200Mbps").tag(3)
                }
                .onChange(of: bitrateIndex) {
                    updateBitrate()
                }
                Picker("Touch Mode", selection: $settings.absoluteTouchMode) {
                    Text("Touchpad").tag(false)
                    Text("Touchscreen").tag(true)
                }
                Picker("On-Screen Controls", selection: $settings.onscreenControls) {
                    Text("Off").tag(0)
                    Text("Auto").tag(1)
                    Text("Simple").tag(2)
                    Text("Full").tag(3)
                }
                Toggle("Optimize Game Settings", isOn: $settings.optimizeGames)
                Picker("Multi-Controller Mode", selection: $settings.multiController) {
                    Text("Single").tag(false)
                    Text("Auto").tag(true)
                }
                Toggle("Swap A/B and X/Y Buttons", isOn: $settings.swapABXYButtons)
                Toggle("Play Audio on PC", isOn: $settings.playAudioOnPC)
                Picker("Preferred Codec", selection: $settings.preferredCodec) {
                    Text("H.264").tag(PreferredCodec.h264)
                    Text("HEVC").tag(PreferredCodec.hevc)
                    Text("AV1").tag(PreferredCodec.av1)
                    Text("Auto").tag(PreferredCodec.auto)
                }
                Toggle("Enable HDR", isOn: $settings.enableHdr)
                Picker("Frame Pacing", selection: $settings.useFramePacing) {
                    Text("Lowest Latency").tag(false)
                    Text("Smoothest Video").tag(true)
                }
                Toggle("Citrix X1 Mouse Support", isOn: $settings.btMouseSupport)
                Toggle("Statistics Overlay", isOn: $settings.statsOverlay)
            }
            .navigationTitle("Settings")
            .onDisappear {
                settings.save()
            }
        }
    }

    let resolutionTable = [CGSize(width: 640, height: 360), CGSize(width: 1280, height: 720), CGSize(width: 1920, height: 1080), CGSize(width: 3840, height: 2160)]
    
    let framerateTable = [30, 60, 90, 120]
    
    let bitrateTable = [10000, 30000, 120000, 200000]

    @MainActor func updateResolution() {
        let resolution = resolutionTable[resolutionIndex]
        settings.width = Int32(resolution.width)
        settings.height = Int32(resolution.height)
    }
    
    @MainActor func updateFramerate() {
        settings.framerate = Int32(framerateTable[framerateIndex])
    }
    
    @MainActor func updateBitrate() {
        settings.bitrate = Int32(bitrateTable[bitrateIndex])
    }
}

#Preview {
    @State var settings = TemporarySettings()
    return SettingsView(settings: $settings)
}