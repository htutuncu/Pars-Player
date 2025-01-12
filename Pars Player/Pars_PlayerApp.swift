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
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified)
    }
}
