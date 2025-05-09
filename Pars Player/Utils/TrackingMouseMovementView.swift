//
//  TrackingMouseMovementView.swift
//  Pars Player
//
//  Created by zorth64 on 09/05/25.
//

import SwiftUI
import AppKit
import Combine

class TrackingMouseMovementView: NSView {
    private var trackingArea: NSTrackingArea?
    
    private var timerCancellable: AnyCancellable? = nil
    private var timerExpired = true
    
    private let duration: TimeInterval = 2.0
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setupTrackingArea()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupTrackingArea()
    }
    
    private func setupTrackingArea() {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        let options: NSTrackingArea.Options = [.mouseMoved, .activeInKeyWindow, .inVisibleRect]
        let newTrackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(newTrackingArea)
        self.trackingArea = newTrackingArea
    }
    
    override func mouseMoved(with event: NSEvent) {
        if (timerExpired) {
            timerExpired = false
            NotificationCenter.default.post(name: .mouseMoved, object: nil )
        }
        timerCancellable?.cancel()

        let timer = Timer.publish(every: duration, on: .main, in: .common).autoconnect()

        timerCancellable = timer.sink { _ in
            NotificationCenter.default.post(name: .mouseStopped, object: nil )
            self.timerExpired = true
        }
    }
}

struct TrackingMouseMovementViewRepresentable: NSViewRepresentable {
    func updateNSView(_ nsView: TrackingMouseMovementView, context: Context) {}

    func makeNSView(context: Context) -> TrackingMouseMovementView {
        let view = TrackingMouseMovementView()
        return view
    }
}

extension Notification.Name {
    static let mouseMoved = Notification.Name("mouseMoved")
    static let mouseStopped = Notification.Name("mouseStopped")
}
