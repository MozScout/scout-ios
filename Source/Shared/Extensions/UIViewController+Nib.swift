
import UIKit

extension NSObject {
    class func defaultNibName() -> String {
        let nibName = NSStringFromClass(self)
        
        let components = nibName.components(separatedBy: ".")
        if components.count == 2 {
            return components[1]
        }
        
        return nibName
    }
}

extension UIView {
    class func loadFromNib(nibName: String? = nil) -> Self? {
        return loadFromNibHelper(nibName: nibName)
    }
    
    class func defaultNib() -> UINib? {
        let nib = UINib(nibName: self.defaultNibName(), bundle: Bundle(for: AppDelegate.self))
        
        return nib
    }
    
    // MARK: - Private
    
    fileprivate class func loadFromNibHelper<T>(nibName: String? = nil) -> T? {
        let nibNameChecked = nibName != nil ? nibName! : self.defaultNibName()
        
        if let view = Bundle(for: AppDelegate.self).loadNibNamed(
            nibNameChecked,
            owner: nil,
            options: nil)?.first as? T {
            
            return view
        }
        else {
            return nil
        }
    }
}

extension UIViewController {
    class func loadFromNib(nibName: String? = nil) -> Self {
        let nibNameChecked = nibName != nil ? nibName! : self.defaultNibName()
        return self.init(nibName: nibNameChecked, bundle: Bundle(for: AppDelegate.self))
    }
    
    class func loadFromStoryboard() -> Self {
        return loadFromStoryboardHelper()
    }
    
    func checkViewIsLoaded() {
        let view = self.view
        self.view = view
    }
    
    // MARK: - Private
    
    fileprivate class func loadFromStoryboardHelper<T>() -> T {
        let storyboardName = self.defaultNibName()
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        let viewController = storyboard.instantiateInitialViewController() as! T
        return viewController
    }
}

extension UIView {
    func hasMutualSuperview(with view: UIView?) -> Bool {
        var selfSuperviews = [UIView]()
        
        var currSelfSuperview = self.superview
        while currSelfSuperview != nil {
            if let currSuper = currSelfSuperview {
                selfSuperviews.append(currSuper)
            }
            
            currSelfSuperview = currSelfSuperview?.superview
        }
        
        var currViewSuperview = view?.superview
        while currViewSuperview != nil {
            if let currSuper = currViewSuperview {
                if selfSuperviews.contains(currSuper) {
                    return true
                }
            }
            
            currViewSuperview = currViewSuperview?.superview
        }
        
        return false
    }
    
    public func printViewHierarchy() -> String {
        var selfSuperviews = [UIView]()
        
        var currSelfSuperview = self.superview
        while currSelfSuperview != nil {
            if let currSuper = currSelfSuperview {
                selfSuperviews.append(currSuper)
            }
            
            currSelfSuperview = currSelfSuperview?.superview
        }
        
        var viewHierarchy = ""
        for (index, view) in selfSuperviews.reversed().enumerated() {
            if index > 0 {
                viewHierarchy.append("\n")
            }
            
            for _ in 0 ..< index {
                viewHierarchy.append(" ")
            }
            
            viewHierarchy.append("-\(view.debugDescription)")
        }
        return viewHierarchy
    }
}
