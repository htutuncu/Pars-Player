# Pars Player

Pars Player is an IPTV player developed for macOS. You can load IPTV lists in M3U format and watch live streams.

## 🚀 Features

- M3U file loading support
- M3U list loading from URL
- Channel search
- Fullscreen support
- Live stream playback
- Playback controls (play, pause, stop)
- Dark theme

## 🛠 Technologies

- Swift 5
- SwiftUI
- VLCKit
- Carthage
- CocoaPods

## 📋 Requirements

- macOS 11.0 or later
- Xcode 14.0 or later
- CocoaPods
- Carthage

## 💻 Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/htutuncu/Pars-Player.git
    cd Pars-Player
    ```

2. Install CocoaPods (if not installed):
    ```bash
    sudo gem install cocoapods
    ```

3. Install Carthage (if not installed):
    ```bash
    brew install carthage
    ```

4. Install dependencies:
    ```bash
    pod install
    carthage update --platform macOS
    ```

5. Open `Pars Player.xcworkspace` with Xcode

6. Build and run the project (`⌘R`)

## 📁 Project Structure

```
Pars Player/
├── Models/
│   └── Channel.swift          # Channel model
├── ViewModels/
│   └── ChannelsViewModel.swift # Channel list management
├── Views/
│   ├── ContentView.swift      # Main view
│   └── PlayerView.swift       # Video player
├── Utils/
│   └── M3UParser.swift        # M3U file parser
```

## 📚 Libraries Used

### VLCKit
VLCKit is a wrapper for VideoLAN's VLC media player for macOS applications. It is used for video playback features.

#### Integration:
1. Added to Podfile:
    ```ruby
    pod 'VLCKit'
    ```

2. Used VLCMediaPlayer in PlayerView.swift:
    ```swift
    import VLCKit
    ```

## ⭐️ Feature Details

### M3U File Support
- Load local M3U files
- Download M3U list from URL
- Parse EXTINF tags
- Read channel name, group, and logo information

### Video Player
- VLCKit integration
- Fullscreen support
- Playback controls
- Time bar
- Volume control

### User Interface
- Modern interface with SwiftUI
- Dark theme support
- Responsive design
- Channel search functionality
- Sidebar navigation

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 📫 Contact

Hikmet Tütüncü - [@htutuncu](https://github.com/htutuncu)

Project Link: [https://github.com/htutuncu/Pars-Player](https://github.com/htutuncu/Pars-Player)