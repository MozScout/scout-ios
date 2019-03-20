//
//  HotwordDetector.swift
//  Scout
//
//

import Foundation

protocol HotwordDetector: class {

    var onDetect: (() -> Void)? { get set }
    var isDetecting: Bool { get }

    func startDetecting()
    func stopDetecting()
}
