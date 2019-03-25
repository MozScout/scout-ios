//
//  Weak.swift
//  Scout
//
//

import Foundation

class Weak<Object: AnyObject> {
    weak var obj: Object?

    init(_ obj: Object) {
        self.obj = obj
    }
}
