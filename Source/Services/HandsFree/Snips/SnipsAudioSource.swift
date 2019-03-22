//
//  SnipsAudioSource.swift
//  Scout
//
//

import Foundation
import AVFoundation

class SnipsAudioSource {

    var onAppendBuffer: ((AVAudioPCMBuffer, AVAudioTime) -> Void)?

    private let audioEngine: AVAudioEngine

    init() {
        audioEngine = AVAudioEngine()
        let sourceFormat = audioEngine.inputNode.outputFormat(forBus: 1)
        let targetFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                         sampleRate: 16000.0,
                                         channels: 1,
                                         interleaved: false)!
        let converter = AVAudioConverter(from: sourceFormat, to: targetFormat)
        audioEngine.inputNode.installTap(
            onBus: 1,
            bufferSize: 4410,
            format: sourceFormat) { [weak self] (buffer: AVAudioPCMBuffer, time: AVAudioTime) in
                let target = AVAudioPCMBuffer(pcmFormat: targetFormat,
                                              frameCapacity: 1600)!
                var error: NSError?
                converter?.convert(to: target, error: &error, withInputFrom: { (_, outStatus) -> AVAudioBuffer? in
                    outStatus.pointee = AVAudioConverterInputStatus.haveData
                    return buffer
                })
                self?.onAppendBuffer?(target, time)
        }

        audioEngine.prepare()
    }
}

extension SnipsAudioSource: AudioSource {

    func start() throws {
        try audioEngine.start()
    }

    func stop() {
        audioEngine.pause()
    }
}
