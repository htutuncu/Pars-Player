import SwiftUI
import Combine

class ChannelsViewModel: ObservableObject {
    @Published var channels: [Channel] = []
    @Published var selectedChannel: Channel?
    @Published var searchText: String = ""
    @Published private(set) var filteredChannels: [Channel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Debounce ile arama işlemini optimize et
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterChannels(searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterChannels(_ searchText: String) {
        if searchText.isEmpty {
            filteredChannels = channels
        } else {
            filteredChannels = channels.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func loadM3UFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.init(filenameExtension: "m3u")].compactMap { $0 }
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    self.channels = M3UParser.parse(content: content)
                    self.filteredChannels = self.channels // İlk yükleme için
                } catch {
                    print("Error loading file: \(error)")
                }
            }
        }
    }
    
    func loadM3UFromURL() {
        let alert = NSAlert()
        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        textField.placeholderString = "Enter M3U URL..."
        
        alert.messageText = "Load M3U from URL"
        alert.informativeText = "Enter the URL of the M3U file:"
        alert.accessoryView = textField
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        if alert.runModal() == .alertFirstButtonReturn {
            let urlString = textField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // URL'nin doğruluğunu kontrol et
            guard let url = URL(string: urlString), url.scheme == "http" || url.scheme == "https" else {
                // Hatalı URL durumunda kullanıcıya bilgi ver
                let invalidUrlAlert = NSAlert()
                invalidUrlAlert.messageText = "Invalid URL"
                invalidUrlAlert.informativeText = "Please enter a valid URL starting with http:// or https://."
                invalidUrlAlert.runModal()
                return
            }

            // URL'den içeriği yükle
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(from: url)
                    
                    // HTTP yanıt kodunu kontrol et
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                        DispatchQueue.main.async {
                            let errorAlert = NSAlert()
                            errorAlert.messageText = "Error"
                            errorAlert.informativeText = "Failed to load URL. HTTP Status Code: \(httpResponse.statusCode)"
                            errorAlert.runModal()
                        }
                        return
                    }
                    
                    // Veriyi metne çevir ve işlem yap
                    if let content = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            self.channels = M3UParser.parse(content: content)
                            self.filteredChannels = self.channels
                        }
                    } else {
                        // Veriyi metne dönüştürme hatası
                        DispatchQueue.main.async {
                            let errorAlert = NSAlert()
                            errorAlert.messageText = "Error"
                            errorAlert.informativeText = "Failed to parse the content of the M3U file."
                            errorAlert.runModal()
                        }
                    }
                } catch {
                    print("Error loading URL: \(error)")
                    
                    // Hata durumunda kullanıcıya bilgi ver
                    DispatchQueue.main.async {
                        let errorAlert = NSAlert()
                        errorAlert.messageText = "Error"
                        errorAlert.informativeText = "Could not load M3U file from the provided URL. Please check the URL or your internet connection."
                        errorAlert.runModal()
                    }
                }
            }
        }

    }
} 
