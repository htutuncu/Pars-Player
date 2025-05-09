//
//  ChannelEditView.swift
//  Pars Player
//
//  Created by zorth64 on 08/05/25.
//

import SwiftUI
import Schwifty
import Combine

struct ChannelEditView: View {
    @StateObject private var channelEditViewModel: ChannelEditViewModel
    
    init(editing: Binding<Bool>, original: Channel?) {
        _channelEditViewModel = StateObject(
            wrappedValue: ChannelEditViewModel(editing: editing, channel: original)
        )
    }
    
    var body: some View {
        VStack {
            Text(channelEditViewModel.viewTitle)
                .font(.title.bold())
                .positioned(.leading)
                .padding(.bottom, 8)
            
            FormField(title: "Name", titleWidth: 50) { TextField("", text: $channelEditViewModel.name) }
            FormField(title: "URL", titleWidth: 50) { TextField("", text: $channelEditViewModel.url) }
                .padding(.bottom, 8)
            
            HStack {
                Spacer()
                Button("Close", action: channelEditViewModel.close).keyboardShortcut(.cancelAction)
                Button("Save", action: channelEditViewModel.save).keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .onSubmit(channelEditViewModel.save)
    }
}

private class ChannelEditViewModel: ObservableObject {
    @Published var viewTitle: String
    @Published var name: String
    @Published var url: String
    
    @Inject var viewModel: ChannelsViewModel
    
    private let id: String
    private let editing: Binding<Bool>
    private var disposables = Set<AnyCancellable>()
    
    init(editing: Binding<Bool>, channel: Channel?) {
        self.editing = editing
        
        id = channel?.id ?? UUID().uuidString
        name = channel?.name ?? ""
        url = channel?.url.absoluteString ?? ""
        viewTitle = channel.let { "Edit '\($0.name)'"} ?? "New Channel"
    }
    
    func close() {
        editing.wrappedValue = false
    }
    
    func save() {
        let item = Channel(id: id, name: name, url: URL(string: url) ?? URL(string: "")!)
        viewModel.add(channel: item)
        editing.wrappedValue = false
    }
}
