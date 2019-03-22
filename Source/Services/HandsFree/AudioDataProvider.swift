//
//  AudioDataProvider.swift
//  Scout
//
//

import Foundation
import AVFoundation

protocol AudioSource: class {

    var onAppendBuffer: ((AVAudioPCMBuffer, AVAudioTime) -> Void)? { get set }

    func start() throws
    func stop()
}

protocol AudioDataProviderObserver: class {

    func appendBuffer(_ buffer: AVAudioPCMBuffer, time: AVAudioTime)
}

class AudioDataProvider {

    typealias StartResult = OperationResult<Void, Error>
    typealias Observer =  AudioDataProviderObserver

    private class ObserverWraper: Observer {

        weak var observer: Observer?
        var isActive = false

        init(_ observer: Observer) {
            self.observer = observer
        }

        func appendBuffer(_ buffer: AVAudioPCMBuffer, time: AVAudioTime) {
            observer?.appendBuffer(buffer, time: time)
        }
    }

    private let source: AudioSource
    private var observers = [ObserverWraper]()
    private var isRun = false

    init(source: AudioSource) {
        self.source = source
        source.onAppendBuffer = { [weak self] buffer, time in
            self?.notifyObservers(with: buffer, time: time)
        }
    }

    func addObserver(_ observer: Observer) {
        guard !observers.contains(where: { $0.observer === observer }) else {
            return
        }

        observers.append(ObserverWraper(observer))
    }

    func removeObserver(_ observer: Observer) {
        observers.removeAll { $0.observer === observer }
    }

    func activate(_ observer: Observer) -> StartResult {
        if isRun {
            setActivity(to: true, for: observer)
        } else {
            switch run() {
            case .success:
                setActivity(to: true, for: observer)
            case .failure(let error):
                return .failure(error: error)
            }
        }

        return .success(data: ())
    }

    func deactivate(_ observer: Observer) {
        setActivity(to: false, for: observer)
        stopIfNeeded()
    }
}

private extension AudioDataProvider {
    func setActivity(to state: Bool, for observer: Observer) {
        observers.first(where: { $0.observer === observer })?.isActive = state
    }

    func run() -> StartResult {
        do {
            try source.start()
        } catch {
            return .failure(error: error)
        }

        isRun = true
        return .success(data: ())
    }

    func stop() {
        isRun = false
        source.stop()
    }

    func stopIfNeeded() {
        guard isRun else { return }

        if !observers.contains(where: { $0.isActive == true }) {
            stop()
        }
    }

    func notifyObservers(with buffer: AVAudioPCMBuffer, time: AVAudioTime) {
        removeDealocatedObservers()
        for observer in observers {
            observer.appendBuffer(buffer, time: time)
        }
    }

    func removeDealocatedObservers() {
        observers.removeAll{ $0.observer == nil }
        stopIfNeeded()
    }
}
