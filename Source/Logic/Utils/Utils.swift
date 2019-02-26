//
//  Utils.swift
//  Scout
//
//

import Foundation
import MediaPlayer
import UIKit

typealias VoidBlock = () -> Void

class WeakPointerArray<ObjectType> {
     var count: Int {
        return weakStorage.count
    }

    fileprivate let weakStorage = NSHashTable<AnyObject>.weakObjects()

     init() {}

     func add(_ object: ObjectType) {
        weakStorage.add(object as AnyObject)
    }

     func remove(_ object: ObjectType) {
        weakStorage.remove(object as AnyObject)
    }

     func removeAllObjects() {
        weakStorage.removeAllObjects()
    }

     func contains(_ object: ObjectType) -> Bool {
        return weakStorage.contains(object as AnyObject)
    }
}

extension WeakPointerArray: Sequence {
     func makeIterator() -> AnyIterator<ObjectType> {
        let enumerator = weakStorage.objectEnumerator()

        return AnyIterator {
            // swiftlint:disable:next force_cast
            return enumerator.nextObject() as! ObjectType?
        }
    }
}

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string: link)! as URL, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.main.async {
                self.contentMode = contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

extension String {
    func contains(word: String) -> Bool {
        return self.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
}
