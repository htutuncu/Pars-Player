//
//  PlayerView.swift
//  Pars Player
//
//  Created by Hikmet Tütüncü on 12.01.2025.
//
import SwiftUI
import VLCKit

class VLCPlayerManager: ObservableObject {
    var player = VLCMediaPlayer()
    @Published var currentPosition: Float = 0.0
    @Published var currentTime: String = "00:00"
    @Published var totalTime: String = "00:00"
    @Published var isFullScreen: Bool = false
    
    let videoView: VLCVideoView
    private var timer: Timer?

    init() {
        videoView = VLCVideoView()
        videoView.wantsLayer = true
        videoView.layer?.backgroundColor = NSColor.black.cgColor
        
        // Video görünüm ayarları
        player.drawable = videoView
        player.videoAspectRatio = nil
        player.videoCropGeometry = nil
        
        // VLCVideoView ayarları
        videoView.fillScreen = false
        videoView.autoresizingMask = [.width, .height]
    }

    deinit {
        player.stop()
        timer?.invalidate()
    }

    func startPlayback() {
        player.play()
        startTimer()
    }

    func pausePlayback() {
        player.pause()
        stopTimer()
    }

    func stopPlayback() {
        player.stop()
        stopTimer()
        resetTime()
    }

    func seek(to position: Float) {
        player.position = position
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.updatePlaybackPosition()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updatePlaybackPosition() {
        DispatchQueue.main.async {
            self.currentPosition = self.player.position
            self.currentTime = self.formatTime(Int(self.player.time.intValue))
            self.totalTime = self.formatTime(Int(self.player.media.length.intValue))
        }
    }

    private func resetTime() {
        currentPosition = 0.0
        currentTime = "00:00"
        totalTime = "00:00"
    }

    private func formatTime(_ milliseconds: Int) -> String {
        let seconds = milliseconds / 1000
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    func toggleFullScreen() {
        if let window = NSApp.keyWindow {
            isFullScreen.toggle()
            
            if isFullScreen {
                // Tam ekran modu
                window.toggleFullScreen(nil)
                videoView.fillScreen = false
                
                // Aspect ratio'yu koru
                if let screen = window.screen {
                    let screenBounds = screen.frame
                    let videoSize = videoView.frame.size
                    let scale = min(
                        screenBounds.width / videoSize.width,
                        screenBounds.height / videoSize.height
                    )
                    
                    let newWidth = videoSize.width * scale
                    let newHeight = videoSize.height * scale
                    let x = (screenBounds.width - newWidth) / 2
                    let y = (screenBounds.height - newHeight) / 2
                    
                    videoView.frame = NSRect(x: x, y: y, width: newWidth, height: newHeight)
                }
            } else {
                // Normal mod
                window.toggleFullScreen(nil)
                videoView.fillScreen = false
                
                // Normal boyuta dön
                if let superview = videoView.superview {
                    videoView.frame = superview.bounds
                }
            }
        }
    }
}

struct VLCPlayerView: NSViewRepresentable {
    @ObservedObject var manager: VLCPlayerManager
    let mediaURL: URL
    
    func makeNSView(context: Context) -> NSView {
        let containerView = NSView()
        containerView.wantsLayer = true
        containerView.layer?.backgroundColor = NSColor.black.cgColor
        
        // Video view'ı container'a ekle
        containerView.addSubview(manager.videoView)
        manager.videoView.frame = containerView.bounds
        manager.videoView.autoresizingMask = [.width, .height]
        
        // Medyayı ayarla ve oynat
        if manager.player.media?.url != mediaURL {
            manager.player.media = VLCMedia(url: mediaURL)
            manager.player.play()
        }
        
        return containerView
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if manager.player.media?.url != mediaURL {
            manager.player.media = VLCMedia(url: mediaURL)
            manager.player.play()
        }
        
        // Video view boyutunu güncelle
        manager.videoView.frame = nsView.bounds
    }
}




