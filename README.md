# Pars Player

Pars Player, macOS için geliştirilmiş bir IPTV oynatıcısıdır. M3U formatındaki IPTV listelerini yükleyebilir ve canlı yayınları izleyebilirsiniz.

## 🚀 Özellikler

- M3U dosyası yükleme desteği
- URL üzerinden M3U listesi yükleme
- Kanal arama
- Tam ekran desteği
- Canlı yayın oynatma
- Oynatma kontrolleri (play, pause, stop)
- Koyu tema

## 🛠 Teknolojiler

- Swift 5
- SwiftUI
- VLCKit
- Carthage
- CocoaPods

## 📋 Gereksinimler

- macOS 11.0 veya üzeri
- Xcode 14.0 veya üzeri
- CocoaPods
- Carthage

## 💻 Kurulum

1. Repository'yi klonlayın:
    ```bash
    git clone https://github.com/htutuncu/Pars-Player.git
    cd Pars-Player
    ```

2. CocoaPods'u yükleyin (eğer yüklü değilse):
    ```bash
    sudo gem install cocoapods
    ```

3. Carthage'ı yükleyin (eğer yüklü değilse):
    ```bash
    brew install carthage
    ```

4. Bağımlılıkları yükleyin:
    ```bash
    pod install
    carthage update --platform macOS
    ```

5. `Pars Player.xcworkspace` dosyasını Xcode ile açın

6. Projeyi derleyin ve çalıştırın (`⌘R`)

## 📁 Proje Yapısı

```
Pars Player/
├── Models/
│   └── Channel.swift          # Kanal modeli
├── ViewModels/
│   └── ChannelsViewModel.swift # Kanal listesi yönetimi
├── Views/
│   ├── ContentView.swift      # Ana görünüm
│   └── PlayerView.swift       # Video oynatıcı
├── Utils/
│   └── M3UParser.swift        # M3U dosya parser'ı
```

## Kullanılan Kütüphaneler

### VLCKit
VLCKit, VideoLAN'ın VLC media player'ının macOS uygulamaları için wrapper'ıdır. Video oynatma özellikleri için kullanılmıştır.

Entegrasyon:
1. Podfile'a eklendi:
ruby
pod 'VLCKit'

2. PlayerView.swift'te VLCMediaPlayer kullanıldı:
swift
import VLCKit


## Özellik Detayları

### M3U Dosya Desteği
- Yerel M3U dosyalarını yükleme
- URL üzerinden M3U listesi indirme
- EXTINF etiketlerini parse etme
- Kanal adı, grup ve logo bilgilerini okuma

### Video Oynatıcı
- VLCKit entegrasyonu
- Tam ekran desteği
- Oynatma kontrolleri
- Zaman çubuğu
- Ses kontrolü

### Kullanıcı Arayüzü
- SwiftUI ile modern arayüz
- Koyu tema desteği
- Responsive tasarım
- Kanal arama özelliği
- Sidebar navigasyonu

## Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch'i oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır - detaylar için [LICENSE.md](LICENSE.md) dosyasına bakın.

## İletişim

Hikmet Tütüncü - [@htutuncu](https://github.com/htutuncu)

Proje Linki: [https://github.com/htutuncu/Pars-Player](https://github.com/htutuncu/Pars-Player)