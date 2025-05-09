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
    
    @State private var showOverlay: Bool = false
    
    init() {
        Dependencies.setup()
    }
    
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
                        HStack(spacing: 4) {
                            Image(systemName: "magnifyingglass")
                                .padding(.leading, 6)
                                .foregroundColor(Color.primary.opacity(0.8))
                            TextField("", text: $viewModel.searchText, prompt: Text("Search channels..."))
                                .textFieldStyle(.plain)
                        }
                        .font(.system(size: 13))
                        .frame(height: 28)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                                .background {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.05))
                                        .cornerRadius(5)
                                }
                            
                        }
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        
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
                    .frame(minWidth: 202)
                    .toolbar {
                        Button(action: toggleSidebar, label: { // 1
                            Image(systemName: "sidebar.leading")
                        }).help("Hide or Show Sidebar")
                        Spacer()
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
                            .opacity(showOverlay ? 1 : 0)
                            
                            TrackingMouseMovementViewRepresentable()
                                .background(.clear)
                                .allowsHitTesting(false)
                        }
                    } else {
                        Text("No Channel Selected")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle(viewModel.selectedChannel != nil ? viewModel.selectedChannel!.name : "Pars Player")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .mouseMoved)) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.showOverlay = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .mouseStopped)) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.showOverlay = false
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}



// Kanal satırı için ayrı bir view
struct ChannelRow: View {
    @EnvironmentObject var viewModel: ChannelsViewModel
    @State var isShowingEditor: Bool = false
    
    let channel: Channel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(channel.name)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .lineLimit(1)
            .truncationMode(.middle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.accentColor.opacity(1) : Color.clear)
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            .contextMenu {
                MenuItem("Edit", icon: "pencil", key: "E", action: edit)
                MenuItem("Delete", icon: "trash", key: "D", action: delete)
            }
            .sheet(isPresented: $isShowingEditor) {
                ChannelEditView(editing: $isShowingEditor, original: channel)
            }
            .onChange(of: isShowingEditor) {
                if (!isShowingEditor) {
                    withAnimation {
                        viewModel.reloadChannels()
                    }
                }
            }
    }
    
    private func edit() {
        isShowingEditor = true
    }
    
    private func delete() {
        withAnimation() {
            viewModel.remove(channel: channel)
        }
    }
}

struct MenuItem: View {
    let title: String
    let icon: String
    let action: () -> Void
    let shortcut: KeyboardShortcut
    
    init(
        _ title: String,
        icon: String = "",
        shortcut: KeyboardShortcut,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.shortcut = shortcut
        self.action = action
    }
    
    init(
        _ title: String,
        icon: String = "",
        key: KeyEquivalent,
        action: @escaping () -> Void
    ) {
        self.init(title, icon: icon, shortcut: .init(key), action: action)
    }
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
        }
        .keyboardShortcut(shortcut)
    }
}

#Preview {
    ContentView()
}
