//
//  UIImage+Extensions.swift
//  Scout
//
//

import UIKit

extension UIImage {

    class var fxListenTabIcon: UIImage { return image() }
    class var fxNotesTabIcon: UIImage { return image() }
    class var fxSubscriptionsTabIcon: UIImage { return image() }

    class var fxPlaceholder: UIImage { return image() }

    class var fxLogo: UIImage { return image() }

    class var fxPlay: UIImage { return image() }
    class var fxPause: UIImage { return image() }
    class var fxJumpForward: UIImage { return image() }
    class var fxJumpBack: UIImage { return image() }
    class var fxTrackThumb: UIImage { return image() }

    class var fxLike: UIImage { return image() }
    class var fxDislike: UIImage { return image() }

    class var fxNote: UIImage { return image() }

    class var fxClose: UIImage { return image() }
    class var fxHide: UIImage { return image() }

    class var fxHandsFreeNavigationBarIcon: UIImage { return image() }
    class var fxSearchNavigationBarIcon: UIImage { return image() }
    class var fxSettingsNavigationBarIcon: UIImage { return image() }

    private static func image(with name: String = #function) -> UIImage {
        let name = name.deletingPrefix("fx")

        guard let image = UIImage(named: name) else {
            print(.error(error: "Cannot get image named \(name)"))
            return UIImage()
        }
        return image
    }
}
