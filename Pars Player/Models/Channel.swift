import Foundation

struct Channel: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let url: URL
    
    // M3U dosyasındaki #EXTINF satırından gelebilecek ek bilgiler için
    var group: String?
    var logo: String?
} 
