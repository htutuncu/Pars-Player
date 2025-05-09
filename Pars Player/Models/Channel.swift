import Foundation

struct Channel: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    let url: URL
    
    // M3U dosyasındaki #EXTINF satırından gelebilecek ek bilgiler için
    var group: String?
    var logo: String?
} 
