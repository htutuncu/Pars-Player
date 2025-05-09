import Foundation

class M3UParser {
    static func parse(content: String) -> [Channel] {
        var channels: [Channel] = []
        var currentName: String?
        var currentGroup: String?
        var currentLogo: String?
        
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            if trimmedLine.isEmpty { continue }
            
            if trimmedLine.starts(with: "#EXTINF:") {
                // EXTINF satırını parse et
                let components = trimmedLine.components(separatedBy: ",")
                if components.count > 1 {
                    currentName = components[1]
                    
                    // Grup bilgisini al
                    if let groupRange = trimmedLine.range(of: "group-title=\""),
                       let endRange = trimmedLine[groupRange.upperBound...].firstIndex(of: "\"") {
                        currentGroup = String(trimmedLine[groupRange.upperBound..<endRange])
                    }
                    
                    // Logo bilgisini al
                    if let logoRange = trimmedLine.range(of: "tvg-logo=\""),
                       let endRange = trimmedLine[logoRange.upperBound...].firstIndex(of: "\"") {
                        currentLogo = String(trimmedLine[logoRange.upperBound..<endRange])
                    }
                }
            } else if !trimmedLine.hasPrefix("#") {
                // URL satırı
                if let url = URL(string: trimmedLine) {
                    let channel = Channel(
                        id: UUID().uuidString,
                        name: currentName ?? "Unnamed Channel",
                        url: url,
                        group: currentGroup,
                        logo: currentLogo
                    )
                    channels.append(channel)
                }
                
                // Değişkenleri sıfırla
                currentName = nil
                currentGroup = nil
                currentLogo = nil
            }
        }
        
        return channels
    }
} 