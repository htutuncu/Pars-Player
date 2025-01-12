//
//  ContentView.swift
//  Pars Player
//
//  Created by Hikmet Tütüncü on 11.01.2025.
//

import SwiftUI
import VLCKit

struct ContentView: View {
    @StateObject private var manager = VLCPlayerManager()
    @EnvironmentObject var viewModel: ChannelsViewModel
    
    var body: some View {
        Group {
            if manager.isFullScreen {
                // Tam ekran modunda sadece video
                if let channel = viewModel.selectedChannel {
                    VLCPlayerView(manager: manager, mediaURL: channel.url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(count: 2) {
                            withAnimation {
                                manager.toggleFullScreen()
                            }
                        }
                }
            } else {
                // Normal modda navigation ve kontroller
                NavigationView {
                    // Sol panel (kanal listesi)
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search channels...", text: $viewModel.searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding(.horizontal)
                        
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.filteredChannels) { channel in
                                    ChannelRow(channel: channel, isSelected: viewModel.selectedChannel?.id == channel.id) {
                                        viewModel.selectedChannel = channel
                                    }
                                }
                            }
                        }
                    }
                    .frame(minWidth: 200)
                    
                    // Sağ panel (video player)
                    if let channel = viewModel.selectedChannel {
                        ZStack(alignment: .bottom) {
                            VLCPlayerView(manager: manager, mediaURL: channel.url)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .onTapGesture(count: 2) {
                                    withAnimation {
                                        manager.toggleFullScreen()
                                    }
                                }
                            
                            // Kontroller
                            VStack(spacing: 0) {
                                // Zaman çubuğu
                                HStack {
                                    Text(manager.currentTime)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .frame(width: 50, alignment: .leading)
                                    
                                    Slider(value: $manager.currentPosition, in: 0...1, onEditingChanged: { isEditing in
                                        if !isEditing {
                                            manager.seek(to: manager.currentPosition)
                                        }
                                    })
                                    .accentColor(.white)
                                    
                                    Text(manager.totalTime)
                                        .foregroundColor(.white)
                                        .font(.caption)
                                        .frame(width: 50, alignment: .trailing)
                                }
                                .padding(.horizontal)
                                
                                // Kontrol düğmeleri
                                HStack(spacing: 20) {
                                    Spacer()
                                    Button(action: { manager.startPlayback() }) {
                                        Image(systemName: "play.fill")
                                            .foregroundColor(.white)
                                    }
                                    Button(action: { manager.pausePlayback() }) {
                                        Image(systemName: "pause.fill")
                                            .foregroundColor(.white)
                                    }
                                    Button(action: { manager.stopPlayback() }) {
                                        Image(systemName: "stop.fill")
                                            .foregroundColor(.white)
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    } else {
                        Text("No Channel Selected")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button("Load M3U File...") {
                                viewModel.loadM3UFile()
                            }
                            Button("Load M3U from URL...") {
                                viewModel.loadM3UFromURL()
                            }
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("")
            }
        }
        .preferredColorScheme(.dark)
    }
}



// Kanal satırı için ayrı bir view
struct ChannelRow: View {
    let channel: Channel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(channel.name)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
    }
}

#Preview {
    ContentView()
}
