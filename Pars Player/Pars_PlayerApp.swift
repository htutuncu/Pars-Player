//
//  Pars_PlayerApp.swift
//  Pars Player
//
//  Created by Hikmet Tütüncü on 11.01.2025.
//

import SwiftUI

@main
struct Pars_PlayerApp: App {
    @StateObject private var channelsViewModel = ChannelsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(channelsViewModel)
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
        .defaultSize(width: 1024, height: 768)
        .defaultPosition(.center)
    }
}
