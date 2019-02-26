//
//  Dispatcher.swift
//  Scout
//
//

import Foundation

class Dispatcher<Recipient> {
    private let queue: DispatchQueue
    private let recipient: Recipient

    init(queue: DispatchQueue, recipient: Recipient) {
        self.queue = queue
        self.recipient = recipient
    }

    func async(_ closure: @escaping (Recipient) -> Void) {
        queue.async {
            closure(self.recipient)
        }
    }

    func sync<Result>(_ closure: (Recipient) -> Result) -> Result {
        return closure(recipient)
    }
}
