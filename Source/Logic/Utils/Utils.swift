//
//  Utils.swift
//  Scout
//
//

import Foundation
import UIKit

typealias VoidBlock = () -> ()

class WeakPointerArray<ObjectType> {
    
     var count: Int {
        return weakStorage.count
    }
    
    fileprivate let weakStorage = NSHashTable<AnyObject>.weakObjects()
    
     init(){}
    
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
            return enumerator.nextObject() as! ObjectType?
        }
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIViewContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async  {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
