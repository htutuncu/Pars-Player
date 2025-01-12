//
//  ContentView.swift
//  Pars Player
//
//  Created by Hikmet Tütüncü on 11.01.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ChannelsViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                // Arama kutusu
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search channels...", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Kanal listesi
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
            
            VStack {
                if let channel = viewModel.selectedChannel {
                    Text(channel.url.absoluteString)
                        .font(.title)
                } else {
                    Text("No Channel Selected")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
