//
//  BackgroundPlayer.swift
//  csdddd
//

import UIKit
import AVFoundation

class BackgroundPlayer: NSObject, AVAudioPlayerDelegate {
    
    private var _player : AVAudioPlayer?
    
    func startPlayer() {
        if (_player != nil && _player!.isPlaying) {
            return
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setMode(.default)
            let route = session.currentRoute.outputs.first?.portType
            if (route != nil) {
                if (route == .headphones || route == .bluetoothA2DP || route == .bluetoothLE || route == .bluetoothHFP) {
                    try session.setCategory(.playAndRecord, options: [.mixWithOthers, .allowBluetooth, .allowBluetoothA2DP])
                } else {
                    try session.setCategory(.playAndRecord, options: [.mixWithOthers, .defaultToSpeaker])
                }
                try session.setActive(true)
                
                let path = sourcePath()
                if (path != nil) {
                    let soundUrl = URL(fileURLWithPath: path!)
                    _player = try AVAudioPlayer.init(contentsOf: soundUrl)
                    _player?.prepareToPlay()
                    _player?.delegate = self
                    _player?.volume = 0.01
                    _player?.numberOfLoops = -1
                    let res = _player?.play()
                    if (res != true) {
                        print("play failed,please turn on audio background mode")
                    }
                }
            }
        } catch {
            print("play failed,please turn on audio background mode")
        }
    }
    
    func sourcePath() ->  String? {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BackgroundPlayer.self)
        #endif
        return bundle.path(forResource: "silent", ofType: "mp3")
    }
    
    func stopPlayer() {
        if (_player != nil) {
            _player?.stop()
            _player = nil
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, options: [.mixWithOthers, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
            } catch {
                print("stop failed,please turn on audio background mode")
            }
        }
    }
}
